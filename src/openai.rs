use crate::sse::SSEvent;
use crate::{ChatMessage, ChatRequest, ChatRole};
use reqwest::header::{HeaderMap, HeaderValue};
use reqwest::{Client, RequestBuilder};
use serde::{Deserialize, Serialize};

const MODEL: &str = "gpt-5";
pub fn get_request(api_key: &str, model: &str, request: ChatRequest) -> RequestBuilder {
    let mut messages = vec![];
    if model != "o1-preview" && model != "o1-mini" {
        messages.push(ChatMessage {
            role: ChatRole::System,
            content: request.system_prompt,
        });
    }
    messages.extend_from_slice(&request.transcript);
    let client = Client::new();
    let url = "https://api.openai.com/v1/chat/completions";
    let mut headers = HeaderMap::new();
    headers.insert(
        "Content-Type",
        HeaderValue::from_static("text/event-stream"),
    );
    headers.insert(
        "Authorization",
        HeaderValue::from_str(&format!("Bearer {}", api_key)).unwrap(),
    );
    let request = RequestJSON {
        model: if model.is_empty() {
            MODEL.to_string()
        } else {
            model.to_string()
        },
        stream: true,
        messages,
    };
    client.post(url).headers(headers).json(&request)
}

pub fn convert_sse(event: SSEvent) -> Option<String> {
    match event.data.as_str() {
        "[DONE]" => None,
        event_json => serde_json::from_str::<ChatEvent>(&event_json)
            .map(|event| event.choices[0].delta.content.clone())
            .unwrap_or_else(|err| panic!("Deserialization error {:?} in |{}|", err, event.data)),
    }
}

#[derive(Debug, Serialize)]
struct RequestJSON {
    model: String,
    stream: bool,
    messages: Vec<ChatMessage>,
}

#[derive(Debug, Deserialize, Serialize)]
struct ChatEvent {
    id: String,
    object: String,
    created: i64,
    model: String,
    pub choices: Vec<Choice>,
}

#[derive(Debug, Deserialize, Serialize)]
struct Choice {
    pub delta: Delta,
    index: i32,
    finish_reason: Option<String>,
}

#[derive(Debug, Deserialize, Serialize)]
struct Delta {
    pub content: Option<String>,
}
