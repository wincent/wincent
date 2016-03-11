; Install packages (http://stackoverflow.com/questions/10092322)
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)

(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))
(or (file-exists-p package-user-dir) (package-refresh-contents))

(package-initialize)

(ensure-package-installed
 'evil
 'evil-leader
 'evil-numbers
 'evil-surround
 ;'evil-tabs
 'linum-relative
 'magit
 'smooth-scrolling
 'web-mode
 'whitespace)

(setq scroll-margin 5
      scroll-conservatively 9999
      scroll-step 1)

(load-theme 'base16-ocean-dark 1)

; Highlight current line.
(global-hl-line-mode 1)

(setq-default tab-width 4 indent-tabs-mode nil)
(define-key global-map (kbd "RET") 'newline-and-indent)
(scroll-bar-mode -1)

; Save/restore command history etc across sessions.
(require 'savehist)
(setq savehist-additional-variables '(extended-command-history global-mark-ring mark-ring search-ring regexp-search-ring))
(setq savehist-file "~/.emacs.d/savehist")
(setq history-length 10000)
(savehist-mode 1)

(require 'helm-config)
(helm-mode 1)

(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key "<SPC>" 'evil-buffer)
(evil-leader/set-key "b" 'helm-buffers-list)
(evil-leader/set-key "o" 'delete-other-windows)
(evil-leader/set-key "q" 'evil-quit)
(evil-leader/set-key "w" 'evil-write)
(evil-leader/set-key "x" 'evil-save-and-close)

(require 'evil)
(evil-mode 1)

(require 'evil-numbers)
(define-key evil-normal-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-x") 'evil-numbers/dec-at-pt)

; Split navigation.
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

; (require 'evil-tabs)
; (global-evil-tabs-mode t)

(require 'evil-surround)
(global-evil-surround-mode 1)

; Relative line numbers.
(require 'linum-relative)
(linum-relative-global-mode)
(setq
  linum-relative-current-symbol ""
  linum-relative-format "%3s ")

; JSX syntax highlighting.
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))

(require 'whitespace)
(global-whitespace-mode)
(setq whitespace-style (quote (tabs newline tab-mark newline-mark)))
(setq whitespace-display-mappings
      (newline-mark 10 [182 10])
      (tab-mark 9 [8677 9] [92 9])))

(unless window-system
  (require 'mouse)
  (xterm-mouse-mode)
  (global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
  (global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1))))
