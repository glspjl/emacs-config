;;; Emacs 28.2 configuration on Debian 12  -*- lexical-binding: t -*-

;;; Package initialization

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-priorities '(("gnu". 10) ("nongnu" . 10))) ;; Prefer elpa over melpa
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package)
  (setq use-package-expand-minimally t))

(use-package bind-key)

(use-package diminish
  :ensure t)

;;; General settings

(use-package cus-edit
  :init
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  :config
  (when (file-exists-p custom-file)
     (load custom-file t)))

(use-package emacs
  :custom
  (inhibit-startup-screen t)
  (initial-major-mode 'fundamental-mode)
  (tool-bar-mode nil)
  (use-dialog-box nil)
  (delete-by-moving-to-trash t)
  (use-short-answers t)
  (confirm-kill-processes nil)
  (tab-always-indent 'complete)
  (fill-column 80)
  :custom-face
  (default ((nil (:family "DejaVu Sans Mono" :height 110))))
  (fixed-pitch ((nil (:family "DejaVu Sans Mono"))))
  (region ((nil (:background "gray75"))))
  (highlight ((nil (:background "lavender"))))
  :config
  (setq kill-buffer-query-functions
        (remq 'process-kill-buffer-query-function
              kill-buffer-query-functions))
  (prefer-coding-system 'utf-8))

(use-package delsel
  :custom
  (delete-selection-mode t))

(use-package simple
  :custom
  (column-number-mode t)
  (read-extended-command-predicate #'command-completion-default-include-p))

(use-package mouse
  :custom
  (context-menu-mode t))

(use-package window
  :bind
  ("M-o" . other-window))

(use-package windmove
  :config
  (windmove-default-keybindings 'meta)
  :diminish)

;;; History

(use-package recentf
  :custom
  (recentf-max-saved-items 10)
  :bind
  ("C-x C-r" . recentf-open-files)
  :config
  (recentf-mode))

(use-package savehist
  :init
  (savehist-mode))

;;; Navigation

(use-package dired
  :custom
  (dired-kill-when-opening-new-dired-buffer t))

(use-package ibuffer
  :bind
  ("C-x C-b" . ibuffer)
  ("C-x 4 C-b" . ibuffer-other-window))

(use-package imenu
  :hook
  ((prog-mode markdown-mode) . imenu-add-menubar-index))

(use-package imenu-list
  :ensure t
  :bind
  ("C-'" . imenu-list-smart-toggle))

(use-package deft
  :ensure t
  :commands deft
  :custom
  (deft-directory (expand-file-name "~/notes/deft"))
  (deft-extensions '("md" "txt" "org")))

;;; Readability

(use-package display-line-numbers
  :hook prog-mode)

(use-package hl-line
  :hook prog-mode)

(use-package goto-addr
  :hook
  ((text-mode prog-mode) . goto-address-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook prog-mode)

;;; Completion

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  :diminish)

(use-package vertico
  :ensure t
  :config
  (vertico-mode))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))
                                   (eglot-capf (styles orderless)))))

(use-package corfu
  :ensure t
  :config
  (global-corfu-mode))

;;; Major modes

(use-package markdown-mode
  :ensure t
  :mode
  ("README\\.md\\'" . gfm-mode)
  :custom
  (markdown-hide-urls t)
  (markdown-command "pandoc -t html")
  :custom-face
  (markdown-code-face ((nil (:background "gray94" :extend t))))
  (markdown-inline-code-face ((nil (:inherit markdown-code-face))))
  (markdown-pre-face ((nil (:inherit markdown-code-face)))))

(use-package yaml-mode
  :ensure t
  :defer t)

;;; Development tools

(use-package eglot
  :ensure t
  :defer t
  :custom
  (eglot-report-progress nil)
  :config
  (face-spec-reset-face 'eglot-mode-line))

(use-package eldoc
  :custom
  (eldoc-echo-area-use-multiline-p nil)
  :init
  (eval-after-load 'eldoc '(diminish 'eldoc-mode)))

(use-package yasnippet
  :ensure t
  :hook
  (prog-mode . yas-minor-mode)
  :diminish yas-minor-mode)

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

(use-package devdocs
  :ensure t
  :defer t)

(use-package magit
  :ensure t
  :defer t)

(use-package pyvenv
  :ensure t
  :defer t
  :config
  (setenv "WORKON_HOME" (expand-file-name "~/.virtualenvs")))

(use-package slime
  :ensure t
  :commands slime
  :config
  (setq inferior-lisp-program "sbcl"))

;;; Custom functions

(defun my/unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun my/unfill-region ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))
