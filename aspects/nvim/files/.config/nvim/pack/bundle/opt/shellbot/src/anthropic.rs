use crate::api::ChatRequest;
use crate::sse::SSEvent;
use crate::ChatMessage;
use reqwest::header::{HeaderMap, HeaderValue};
use reqwest::{Client, RequestBuilder};
use serde::{Deserialize, Serialize};

const MODEL: &str = "claude-opus-4-6";
pub fn get_request(api_key: &str, model: &str, request: ChatRequest) -> RequestBuilder {
    let client = Client::new();
    let url = "https://api.anthropic.com/v1/messages";
    let mut headers = HeaderMap::new();
    headers.insert(
        "Content-Type",
        HeaderValue::from_static("text/event-stream"),
    );
    headers.insert(
        "X-Api-Key",
        HeaderValue::from_str(&format!("{}", api_key)).unwrap(),
    );
    headers.insert(
        "anthropic-version",
        HeaderValue::from_str("2023-06-01").unwrap(),
    );
    headers.insert(
        "Anthropic-Beta",
        HeaderValue::from_str("messages-2023-12-15").unwrap(),
    );

    let request = RequestJSON {
        model: if model.is_empty() {
            MODEL.to_string()
        } else {
            model.to_string()
        },
        system: request.system_prompt,
        messages: request.transcript,
        stream: true,
        max_tokens: 2048,
    };
    client.post(url).headers(headers).json(&request)
}

pub fn convert_sse(event: SSEvent) -> Option<String> {
    match event.name {
        Some(name) if name == "content_block_delta" => {
            serde_json::from_str::<ContentBlockDelta>(&event.data)
                .map(|data| Some(data.delta.text))
                .unwrap_or_else(|err| panic!("Deserialization error {:?} in |{}|", err, event.data))
        }
        Some(name)
            if matches!(
                &*name,
                "message_start"
                    | "content_block_start"
                    | "ping"
                    | "message_stop"
                    | "content_block_stop"
                    | "message_delta"
            ) =>
        {
            None
        }
        _ => {
            eprintln!("n {:?}", event.name);
            eprintln!("d {:?}", event.data);
            None
        }
    }
}

#[derive(Debug, Serialize)]
struct RequestJSON {
    model: String,
    stream: bool,
    messages: Vec<ChatMessage>,
    system: String,
    max_tokens: usize,
}

#[derive(Deserialize, Debug)]
struct ContentBlockDelta {
    delta: Delta,
}

#[derive(Deserialize, Debug)]
struct Delta {
    text: String,
}
