use regex::{Regex, RegexBuilder};

pub struct SSEvent {
    pub name: Option<String>,
    pub data: String,
}

use std::sync::Arc;

pub struct SSEConverter {
    sse_re: Arc<Regex>,
}

impl SSEConverter {
    pub fn new() -> Self {
        let sse_re = Arc::new(
            RegexBuilder::new(r"^(?:event:\s(\w+)\n)?data:\s(.*)$")
                .multi_line(true)
                .build()
                .expect("Failed to compile Regex."),
        );
        SSEConverter { sse_re }
    }

    pub fn convert(&self, message: String) -> Option<SSEvent> {
        // Empty messages are ok
        if message == "" {
            return None;
        }

        let caps = self.sse_re.captures(&message).unwrap();

        let name = caps.get(1).map(|m| m.as_str().to_owned());
        let data = caps.get(2).unwrap().as_str().to_owned();
        Some(SSEvent { name, data })
    }
}
