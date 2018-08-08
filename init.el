(require 'package)
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/"))
(package-initialize)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq
   backup-by-copying t
   backup-directory-alist '(("." . "~/.saves"))
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)
(setq auto-save-file-name-transforms `((".*" "~/.saves/autosaves/" t)))

(setq inhibit-startup-message t)


(use-package general
  :ensure t)

(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (evil-mode 1)
  :config
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (delete 'term-mode evil-insert-state-modes)
  (add-to-list 'evil-emacs-state-modes 'term-mode)
  :ensure t)

(use-package undo-tree
  :config
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.saves/undo")))
  :ensure t)

(use-package ivy
  :ensure t
  :init
  (ivy-mode)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (global-set-key "\C-s" 'swiper))

(use-package counsel
  :ensure t)

(use-package swiper
  :ensure t)

(use-package nlinum-relative
  :ensure t
  :config
  (nlinum-relative-setup-evil)
  (add-hook 'prog-mode-hook 'nlinum-relative-mode)
  (setq nlinum-relative-redisplay-delay 0)
)

(use-package lsp-mode
  :ensure t)

(use-package lsp-ui
  :ensure t)

(use-package company-lsp
  :config
  (push 'company-lsp company-backends)
  :ensure t)

(use-package cquery
    :commands lsp-cquery-enable
    :init
    (defun cquery//enable ()
      (condition-case nil
	  (lsp-cquery-enable)
	(user-error nil)))
    (add-hook 'c-mode-common-hook #'cquery//enable))

(use-package ivy-xref
  :ensure t
  :init (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(use-package company
  :init
  (setq company-tooltip-align-annotations t)
  (global-company-mode)
  :ensure t)

(use-package company-quickhelp
  :config
  (setq company-quickhelp-delay nil)
  (general-define-key
   :keymaps 'company-active-map
   "C-h" 'company-quickhelp-manual-begin
   )
  (add-hook 'company-mode-hook 'company-quickhelp-mode)
  :ensure t)

(general-define-key
  :prefix "SPC"
  :states 'normal
  :keymaps '(prog-mode-map latex-mode-map)
  "b" 'xref-pop-marker-stack
  "d" 'xref-find-definitions
  "r" 'xref-find-references
  "s" 'counsel-rg
  "u" 'counsel-imenu
  "{" 'compile
  "[" 'recompile)

(use-package flycheck
  :config
  (add-hook 'prog-mode-hook 'flycheck-mode)
  :ensure t)

(use-package magit
  :ensure t)

(use-package evil-magit
  :ensure t)

;==============================
; RUST

(use-package rust-mode
  :ensure t)

(use-package cargo
  :init
  (general-define-key
   :prefix "SPC"
   :states 'normal
   :keymaps 'cargo-mode-map
   "[" 'cargo-process-check
   "{" 'cargo-process-test)
  (setq cargo-process--command-check "check --all --examples")
  (general-define-key
   :keymaps 'cargo-process-mode-map
   "h" nil)
  :ensure t)


(use-package lsp-rust
  :ensure t
  :config
  (setq lsp-rust-rls-command '("rustup" "run" "nightly" "rls"))
  (add-hook 'rust-mode-hook #'lsp-rust-enable)
  (add-hook 'rust-mode-hook #'flycheck-mode))

(use-package racer
  :init
;  (general-define-key
;   :prefix "SPC"
;   :states 'normal
;   :keymaps 'racer-mode-map
;   "d" 'racer-find-definition
;   "h" 'racer-describe)
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode)
  (add-to-list 'evil-emacs-state-modes 'racer-help-mode)
  :ensure t)


;(use-package flycheck-rust
;  :init
;  (add-hook 'rust-mode-hook #'flycheck-mode)
;  :ensure t)

;==============================

;==============================
;PROJECTILE

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "Δ") 'projectile-run-term)
  (setq projectile-completion-system 'ivy)
  (projectile-mode +1))

(use-package projectile-ripgrep
  :ensure t)

(use-package counsel-projectile
  :config
  (counsel-projectile-mode)
  (defun contextual-counsel-rg ()
    (if (projectile-project-p) ;; detect if current buffer is in a project
	(general-define-key
	 :prefix "SPC"
	 :states 'normal
	 :keymaps 'projectile-mode-map
	 "s" 'counsel-projectile-rg)
      (general-define-key
       :prefix "SPC"
       :states 'normal
       :keymaps 'projectile-mode-map
       "s" 'counsel-rg)
      ))
  (add-hook 'projectile-mode-hook #'contextual-counsel-rg)
  :ensure t)

(general-define-key
  :prefix "SPC"
  :states 'normal
  :keymaps 'projectile-mode-map
  "/" 'projectile-ripgrep
  "'" 'counsel-projectile-find-file
  "\"" 'counsel-projectile-find-dir
  ";" 'counsel-projectile-switch-to-buffer
 )

;==============================

;macos
(when (string= "darwin" system-type)
    (use-package exec-path-from-shell
      :init
      (exec-path-from-shell-initialize)
      :ensure t)
    (set-frame-parameter nil 'fullscreen 'maximized))


(use-package solarized-theme
  :ensure t)

(use-package dumb-jump
  :config
  (general-define-key
   :prefix "SPC"
   :states 'normal
   :keymaps 'prog-mode-map
   "j" 'dumb-jump-go)
  (setq dumb-jump-selector 'ivy)
  :ensure t)


(use-package sml-mode
  :ensure t)

;; Source: http://www.emacswiki.org/emacs-en/download/misc-cmds.el
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))


;(use-package ranger
;  :config
;  (ranger-override-dired-mode t)
;  :ensure t)
