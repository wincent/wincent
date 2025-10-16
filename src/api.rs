use bytes::Bytes;
use futures::stream::StreamExt;
use log::debug;
use reqwest::RequestBuilder;
use serde::{Deserialize, Serialize};
use tokio::sync::mpsc::{self, Receiver, Sender};

use crate::anthropic;
use crate::openai;
use crate::sse::SSEConverter;
use crate::sse::SSEvent;

pub enum ApiProvider {
    OpenAI(String, String),
    Anthropic(String, String),
}

pub fn stream_response<'a>(provider: ApiProvider, request: ChatRequest) -> Receiver<String> {
    let request = match provider {
        ApiProvider::OpenAI(ref api_key, ref model) => {
            openai::get_request(&api_key, &model, request)
        }
        ApiProvider::Anthropic(ref api_key, ref model) => {
            anthropic::get_request(&api_key, &model, request)
        }
    };
    let (sender, receiver) = mpsc::channel(100);
    tokio::spawn(async move { send_response(&provider, request, sender).await });
    return receiver;
}

fn debug_request(client: RequestBuilder) {
    let cloned_request = client.build().unwrap();
    // Print request details
    debug!("Request details:");
    debug!("  Method: {}", cloned_request.method());
    debug!("  URL: {}", cloned_request.url());
    debug!("  Headers:");
    for (name, value) in cloned_request.headers() {
        debug!("    {}: {:?}", name, value);
    }

    if let Some(body) = cloned_request.body() {
        debug!("  Body:");
        let body_string = body
            .as_bytes()
            .and_then(|bytes| std::str::from_utf8(bytes).ok());
        if let Some(body_text) = body_string {
            debug!("    {}", body_text);
        } else {
            debug!("    (non-UTF-8 or empty body)");
        }
    } else {
        debug!("    (no body)");
    }
}

async fn send_response(provider: &ApiProvider, client: RequestBuilder, sender: Sender<String>) {
    debug_request(client.try_clone().unwrap());
    let stream = client.send().await.expect("Request failed").bytes_stream();
    let mut buffer = String::new();
    let sse_converter = &SSEConverter::new();

    stream
        .map(|chunk_result| {
            let result = chunk_result.expect("Stream error");
            buffer.push_str(&convert_chunk(result));
            let (m, rest) = process_buffer(&buffer);
            buffer = rest.to_string();
            m.into_iter()
                .filter_map(|string_sse| sse_converter.convert(string_sse))
                .filter_map(|sse| process_sse(&provider, sse))
                .collect::<Vec<String>>()
                .join("")
        })
        .for_each(|str| async {
            sender.send(str).await.expect("Failed to send token");
        })
        .await;

    // If there's any remaining content in the buffer, it's an error
    if !buffer.is_empty() {
        eprintln!("{}", buffer);
    }
}

fn process_buffer(input: &String) -> (Vec<String>, String) {
    let mut parts: Vec<String> = input.split("\n\n").map(String::from).collect();
    let remainder = if input.ends_with("\n\n") {
        None
    } else {
        parts.pop()
    };
    (parts, remainder.unwrap_or(String::new()))
}

fn convert_chunk(chunk: Bytes) -> String {
    std::str::from_utf8(&chunk)
        .map(String::from)
        .expect("Encoding error")
}

fn process_sse(provider: &ApiProvider, event: SSEvent) -> Option<String> {
    match provider {
        ApiProvider::Anthropic(_, _) => anthropic::convert_sse(event),
        ApiProvider::OpenAI(_, _) => openai::convert_sse(event),
    }
}

#[derive(Debug)]
pub struct ChatRequest {
    pub system_prompt: String,
    pub transcript: Vec<ChatMessage>,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct ChatMessage {
    pub role: ChatRole,
    pub content: String,
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Clone)]
#[serde(rename_all = "lowercase")]
pub enum ChatRole {
    User,
    System,
    Assistant,
}
