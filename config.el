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
(setq doom-theme 'doom-horizon)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-roam-directory "~/org-roam")
;;(setq org-agenda-files (list "inbox.org" "agenda.org" "notes.org" "projects.org"))

(setq org-ellipsis "⤵")
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))
(after! org
  (setq org-todo-keywords '((sequence "TODO(t)" "INPROGRESS(i)" "WAIITING(w)" "|" "DONE(d)" "CANCELLED(c)"))
        org-priority-faces '((65 :foreground "#e45649")
                             (66 :foreground "#da8548")
                             (67 :foreground "#0098dd"))
        )
  (setq org-agenda-files (list "inbox.org" "agenda.org"
                             "notes.org" "projects.org"))

  (setq org-capture-templates
      `(("i" "Inbox" entry  (file "inbox.org")
        ,(concat "* TODO %?\n"
                 "/Entered on/ %U"))
        ("m" "Meeting" entry  (file+headline "agenda.org" "Future")
        ,(concat "* %? :meeting:\n"
                 "<%<%Y-%m-%d %a %H:00>>"))
        ("n" "Note" entry  (file "notes.org")
        ,(concat "* Note (%a)\n"
                 "/Entered on/ %U\n" "\n" "%?"))))
        ;; ("@" "Inbox [mu4e]" entry (file "inbox.org")
        ;; ,(concat "* TODO Reply to \"%a\" %?\n"
        ;;          "/Entered on/ %U"))))
  )

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
(use-package forge :after magit)

(setq lsp-log-io t)
(after! elpher
  (setq gnutls-verify-error nil))
(setq deft-directory "~/org"
      deft-extensions '("org", "md")
      deft-default-extension "org"
      deft-recursive t
      deft-use-filename-as-title t
      deft-use-filter-string-for-filename t
      deft-text-mode 'org-mode
      deft-file-naming-rules  '((noslash . "-")
                                (nospace . "-")
                                (case-fn . downcase))
      )

;; Spring boot support
(require 'lsp-java-boot)

;; to enable the lenses
(add-hook 'lsp-mode-hook #'lsp-lens-mode)
(add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)

;; python
(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp))))

(use-package scala-mode
  :mode "\\.s\\(cala\\|bt\\|c\\)$")
