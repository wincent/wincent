mod anthropic;
mod api;
mod openai;
mod sse;

use api::{stream_response, ApiProvider, ChatMessage, ChatRequest, ChatRole};

use log::debug;
use log::LevelFilter;
use std::fs::File;
use std::io::{stdin, Read};
use tokio;
use tokio::io::{stdout, AsyncWriteExt};

#[tokio::main]
async fn main() {
    if let Ok(log_file_path) = std::env::var("SHELLBOT_LOG_FILE") {
        log4rs::init_config(
            log4rs::config::Config::builder()
                .appender(
                    log4rs::config::Appender::builder().build(
                        "file",
                        Box::new(
                            log4rs::append::file::FileAppender::builder()
                                .build(log_file_path)
                                .unwrap(),
                        ),
                    ),
                )
                .build(
                    log4rs::config::Root::builder()
                        .appender("file")
                        .build(LevelFilter::Debug),
                )
                .unwrap(),
        )
        .unwrap();
    }
    let request = structure_input();
    let provider = std::env::var("ANTHROPIC_API_KEY")
        .map(|key| {
            let model = std::env::var("ANTHROPIC_MODEL").unwrap_or_default();
            ApiProvider::Anthropic(key, model)
        })
        .or_else(|_| {
            std::env::var("OPENAI_API_KEY").map(|key| {
                let model = std::env::var("OPENAI_MODEL").unwrap_or_default();
                ApiProvider::OpenAI(key, model)
            })
        })
        .unwrap_or_else(|_| panic!("No API key provided"));
    let mut receiver = stream_response(provider, request);

    let mut out = stdout();
    while let Some(token) = receiver.recv().await {
        out.write_all(token.as_bytes()).await.unwrap();
        out.flush().await.unwrap();
    }
    // Append newline to end of output
    out.write_all(b"\n").await.unwrap();
}

fn get_default_prompt() -> String {
    vec![
        "You are a helpful assistant who provides brief explanations and short code snippets",
        "for linux command-line tools and languages like neovim, Docker, Rust and Python.",
        "Your user is an expert programmer. You do not show lengthy steps or setup instructions.",
        "Only provide answers in cases where you know the answer. Feel free to say \"I don't know.\"",
        "Do not suggest contacting support."
    ].join(" ")
}

fn structure_input() -> ChatRequest {
    let mut input = String::new();
    stdin().read_to_string(&mut input).unwrap();
    let mut lines_iter = input.lines().map(|line| format!("{}\n", line));

    let first_line: String = lines_iter.next().unwrap();
    let args: Vec<String> = std::env::args().collect();
    let system_prompt = if args.len() > 1 {
        let file_path = &args[1];
        let mut file = File::open(file_path).unwrap_or_else(|_| {
            panic!("Failed to open file: {}", file_path);
        });
        let mut contents = String::new();
        file.read_to_string(&mut contents).unwrap();
        contents
    } else {
        get_default_prompt()
    };

    match match_separator(&first_line) {
        None => ChatRequest {
            system_prompt,
            transcript: vec![ChatMessage {
                role: ChatRole::User,
                content: input,
            }],
        },
        Some(first_role) => {
            debug!("First role is {:?}", first_role);
            let mut transcript = parse_transcript(first_role, lines_iter.collect());
            let system_prompt = if transcript.get(0).unwrap().role == ChatRole::System {
                transcript.remove(0).content
            } else {
                system_prompt
            };
            ChatRequest {
                system_prompt,
                transcript,
            }
        }
    }
}

fn parse_transcript(first_role: ChatRole, lines: Vec<String>) -> Vec<ChatMessage> {
    let new_message = |role: ChatRole| ChatMessage {
        role,
        content: String::new(),
    };
    lines.into_iter().fold(
        vec![new_message(first_role)],
        |mut acc: Vec<ChatMessage>, line| {
            match match_separator(&line) {
                Some(role) => acc.push(new_message(role)),
                None => {
                    let last = acc.last_mut().unwrap();
                    last.content = format!("{}{}", last.content, line)
                }
            }
            acc
        },
    )
}

fn match_separator(line: &str) -> Option<ChatRole> {
    match line.trim_end() {
        "===SYSTEM===" => Some(ChatRole::System),
        "===USER===" => Some(ChatRole::User),
        "===ASSISTANT===" => Some(ChatRole::Assistant),
        _ => None,
    }
}
