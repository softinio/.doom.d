;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Salar Rahmanian"
      user-mail-address "salar@softinio.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-snazzy)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/gdrive/org/")
;;(setq org-agenda-files (list "inbox.org" "agenda.org" "notes.org" "projects.org"))

(setq org-ellipsis "⤵")
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq doom-font (font-spec :family "SF Mono" :size 20 :weight 'normal))
(when (string= system-type "darwin")
  (setq dired-use-ls-dired t
        insert-directory-program "/opt/local/bin/gls"
        dired-listing-switches "-aBhl --group-directories-first"))
(setq
 projectile-project-search-path '("~/Project/", "~/OpenSource/")
 auth-sources '("~/.authinfo.gpg")
 )
;; Start maximised (cross-platf)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)
(setq doom-themes-treemacs-theme "doom-colors")
(use-package forge
  :after magit)

(setq select-enable-primary t)

;; (setq lsp-log-io t)

;; Enable defer and ensure by default for use-package
;; Keep auto-save/backup files separate from source code:  https://github.com/scalameta/metals/issues/1027
(setq use-package-always-defer t
      use-package-always-ensure t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Enable scala-mode for highlighting, indentation and motion commands
(use-package scala-mode
  :interpreter
    ("scala" . scala-mode))

;; Enable sbt mode for executing sbt commands
(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
   ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
   (setq sbt:program-options '("-Dsbt.supershell=false"))
)

;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  :hook  (scala-mode . lsp)
         (lsp-mode . lsp-lens-mode)
  :config (setq lsp-prefer-flymake nil))

;; Add metals backend for lsp-mode
(use-package lsp-metals
  :config (setq lsp-metals-treeview-show-when-views-received t))

;; Enable nice rendering of documentation on hover
(use-package lsp-ui)

;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;;   to avoid odd behavior with snippets and indentation
(use-package yasnippet)

;; Add company-lsp backend for metals
(use-package company-lsp)

;; Use the Debug Adapter Protocol for running tests and debugging
(use-package posframe
  ;; Posframe is a pop-up tool that must be manually installed for dap-mode
  )
(use-package dap-mode
  :hook
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode)
  )
(map! :map scala-mode-map
          :localleader
          :desc "Compile" :n "c" (λ! (sbt-command "compile"))
          :desc "Reload" :n "d" (λ! (sbt-command "reload"))
          :desc "Console" :n "o" #'run-scala
          :desc ":paste region" :n "p" #'sbt-paste-region
          :desc "Run" :n "r" (λ! (sbt-command "run"))
          :desc "sbt command" :n "s" #'sbt-command
          :desc "Clear" :n "x" #'sbt-clear
          (:prefix ("m". "metals")
            :desc "List errors" :n "e" #'lsp-ui-flycheck-list
            :desc "Fix missing import" :n "i" #'lsp-execute-code-action
            :desc "Describe thing at point" :n "t" #'lsp-describe-thing-at-point
            :desc "Toggle type hints" :n "H" #'lsp-ui-doc-mode
            :desc "Format buffer" :n "F" #'lsp-format-buffer
            :desc "Format region" :n "f" #'lsp-format-region
            :desc "Find references" :n "C-f" #'lsp-find-references
            :desc "Rename" :n "r" #'lsp-rename
            :desc "Goto implementation" :n "g" #'lsp-goto-implementation))

