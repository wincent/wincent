(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

(require 'helm-config)
(helm-mode 1)

(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key "b" 'helm-buffers-list)
(evil-leader/set-key "q" 'evil-quit)
(evil-leader/set-key "w" 'evil-write)
(evil-leader/set-key "x" 'evil-save-and-close)

(require 'evil)
(evil-mode 1)

(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'linum-relative)
(linum-relative-global-mode)
(setq
  linum-relative-current-symbol ""
  linum-relative-format "%3s ")
