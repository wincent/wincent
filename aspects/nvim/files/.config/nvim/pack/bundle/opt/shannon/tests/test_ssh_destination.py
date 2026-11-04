import os
from pathlib import Path
import runpy
import struct
import subprocess
import sys
import unittest


ROOT = Path(__file__).resolve().parents[1]
HELPER = ROOT / "bin" / "ssh-destination"
FUNCTIONS = runpy.run_path(str(HELPER))
ssh_destination = FUNCTIONS["ssh_destination"]
decode_macos_argv = FUNCTIONS["decode_macos_argv"]
decode_linux_argv = FUNCTIONS["decode_linux_argv"]
read_argv = FUNCTIONS["read_argv"]


class DestinationTests(unittest.TestCase):
    def test_options(self):
        cases = [
            (["ssh", "vm"], "vm"),
            (["/usr/bin/ssh", "admin@vm"], "admin@vm"),
            (["ssh", "-vvNt", "vm"], "vm"),
            (["ssh", "-2", "vm"], "vm"),
            (["ssh", "-24v", "vm"], "vm"),
            (["ssh", "-p", "2222", "vm"], "vm"),
            (["ssh", "-vp2222", "vm"], "vm"),
            (["ssh", "-oLocalCommand=echo hello", "vm"], "vm"),
            (["ssh", "-i", "/tmp/key with spaces", "vm"], "vm"),
            (["ssh", "-S/tmp/control socket", "vm"], "vm"),
            (["ssh", "-B", "en0", "-P", "tag", "vm"], "vm"),
            (["ssh", "--", "vm", "-o", "remote command"], "vm"),
            (["ssh", "vm", "-unknown-remote-option"], "vm"),
            (["ssh", "ssh://admin@vm:2222"], "ssh://admin@vm:2222"),
        ]
        for argv, expected in cases:
            with self.subTest(argv=argv):
                self.assertEqual(ssh_destination(argv), expected)

    def test_sb_local_command(self):
        argv = [
            "ssh", "-M", "-S", "/tmp/lease/control",
            "-o", "ControlPersist=no",
            "-o", "PermitLocalCommand=yes",
            "-o", "LocalCommand=/bin/bash /tmp/lease/forwards &",
            "-o", "ExitOnForwardFailure=yes",
            "-R", "127.0.0.1:49993:127.0.0.1:54754",
            "-o", "StrictHostKeyChecking=no",
            "-o", "UserKnownHostsFile=/dev/null",
            "-o", "LogLevel=ERROR",
            "-o", "ConnectTimeout=5",
            "-o", "ControlPath=none",
            "-o", "SendEnv=LANG",
            "-o", "SendEnv=LC_*",
            "admin@192.168.64.28", "-t", "export VAR=value\nexec zsh -l",
        ]
        self.assertGreater(len(" ".join(argv[:argv.index("admin@192.168.64.28")])), 280)
        self.assertEqual(ssh_destination(argv), "admin@192.168.64.28")

    def test_all_value_options(self):
        for option in "BbcDEeFIiJLlmOopPQRSWw":
            for args in (["-" + option, "value with spaces"],
                         ["-" + option + "value with spaces"]):
                with self.subTest(args=args):
                    self.assertEqual(ssh_destination(["ssh"] + args + ["vm"]), "vm")
                    self.assertIsNone(ssh_destination(["ssh", "-" + option]))

    def test_rejects_unsafe_or_incomplete_arguments(self):
        for argv in ([], ["ssh"], ["sshd", "vm"], ["bash", "ssh", "vm"],
                     ["ssh", "-!", "vm"], ["ssh", "--unknown", "vm"],
                     ["ssh", "-o", "HostName=vm"], ["ssh", ""],
                     ["ssh", "bad\nhost"], ["ssh", "--", "-badhost"]):
            with self.subTest(argv=argv):
                self.assertIsNone(ssh_destination(argv))


class ArgumentDecodingTests(unittest.TestCase):
    def test_macos_padding_empty_arguments_and_environment(self):
        argv = [b"ssh", b"-o", b"LocalCommand=echo 'hello world'", b"vm",
                b"", b"echo a\nb", b"non-utf8-\xff"]
        for padding in (0, 1, 8):
            data = (struct.pack("i", len(argv)) + b"/usr/bin/ssh\0" +
                    b"\0" * padding + b"\0".join(argv) + b"\0SECRET=ignored\0")
            self.assertEqual(decode_macos_argv(data), [os.fsdecode(arg) for arg in argv])

    def test_macos_malformed(self):
        for data in (b"", struct.pack("i", -1), struct.pack("i", 0),
                     struct.pack("i", 2) + b"/usr/bin/ssh",
                     struct.pack("i", 2) + b"/usr/bin/ssh\0ssh\0"):
            with self.subTest(data=data):
                with self.assertRaises(ValueError):
                    decode_macos_argv(data)

    def test_linux_preserves_boundaries(self):
        argv = [b"ssh", b"-o", b"LocalCommand=echo hello", b"vm", b"", b"\xff"]
        self.assertEqual(decode_linux_argv(b"\0".join(argv) + b"\0"),
                         [os.fsdecode(arg) for arg in argv])
        self.assertEqual(decode_linux_argv(b""), [])
        with self.assertRaises(ValueError):
            decode_linux_argv(b"ssh\0vm")


@unittest.skipUnless(sys.platform == "darwin" or sys.platform.startswith("linux"),
                     "requires macOS or Linux process APIs")
class LiveProcessTests(unittest.TestCase):
    def setUp(self):
        # A harmless Python child with an SSH-shaped argv. No network connection.
        # Both Python and SSH consume the argument following -c, so subsequent
        # options can exercise SSH parsing without Python interpreting them.
        self.argv = [
            "ssh", "-c", "import sys; print('ready', flush=True); sys.stdin.read()",
            "-o", "LocalCommand=/bin/bash /tmp/lease/forwards &",
            "admin@fixture.invalid", "", "echo 'hello world'\nexit",
        ]
        executable = sys.executable
        if sys.platform == "darwin":
            # Framework launchers re-exec Python and replace argv[0]. Bypass
            # the launcher so the fixture keeps its SSH-shaped argument vector.
            framework_binary = Path(sys.base_prefix) / "Resources/Python.app/Contents/MacOS/Python"
            if framework_binary.is_file():
                executable = str(framework_binary)
        self.child = subprocess.Popen(self.argv, executable=executable,
                                      stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        self.addCleanup(self.stop_child)
        self.assertEqual(self.child.stdout.readline(), b"ready\n")

    def stop_child(self):
        self.child.terminate()
        self.child.communicate(timeout=10)

    def test_native_argument_reader(self):
        self.assertEqual(read_argv(self.child.pid), self.argv)

    def test_cli(self):
        result = subprocess.run([sys.executable, str(HELPER), str(self.child.pid)],
                                capture_output=True, text=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, "admin@fixture.invalid\n")
        self.assertEqual(result.stderr, "")

    def test_non_ssh_and_exited_process(self):
        self.child.terminate()
        self.child.wait(timeout=10)
        for pid in (os.getpid(), self.child.pid):
            result = subprocess.run([sys.executable, str(HELPER), str(pid)],
                                    capture_output=True, text=True, timeout=10)
            self.assertEqual(result.returncode, 1)
            self.assertEqual(result.stdout, "")
            self.assertEqual(result.stderr, "")

    def test_invalid_pid(self):
        for pid in ("0", "-1", "2147483648", "not-a-pid"):
            result = subprocess.run([sys.executable, str(HELPER), pid],
                                    capture_output=True, text=True, timeout=10)
            self.assertEqual(result.returncode, 2)
            self.assertEqual(result.stdout, "")

    def test_shell_detection_paths(self):
        handler = ROOT / "bin" / "nvim-open"
        source = handler.read_text()
        self.assertTrue(source.endswith('main "$@"\n'))
        source = source[:-len('main "$@"\n')]
        # Keep the real extraction helper; mock only discovery of candidate PIDs.
        fixtures = """
LOG=/dev/null
kitten() { :; }
jq() { printf '%s\\n' "$NON_SSH_PID" "$SSH_PID"; }
tmux() { printf '/dev/fixture\\n'; }
ps() {
  if [ "$*" != '-t fixture -o pid=' ]; then return 1; fi
  printf '%s\\n' "$NON_SSH_PID" "$SSH_PID"
}
"""
        env = dict(os.environ, SSH_PID=str(self.child.pid), NON_SSH_PID=str(os.getpid()))
        for call in ('find_ssh_in_match "id:5" "unix:fixture"',
                     'find_ssh_in_sole_window "unix:fixture"',
                     'detect_ssh_via_tmux'):
            with self.subTest(call=call):
                result = subprocess.run(["bash", "-c", source + fixtures + call,
                                         str(handler)], env=env, capture_output=True,
                                        text=True, timeout=10)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stdout, "admin@fixture.invalid\n")
                self.assertEqual(result.stderr, "")


if __name__ == "__main__":
    unittest.main()
