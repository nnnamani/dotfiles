(defsystem "lem-my-init"
  :author "yuji suzuki"
  :license "BSD 2-Clause"
  :description "Configurations for lem"
  :serial t
  :depends-on ("lem-lisp-mode")
  :components ((:file "general-settings/10-key-binds")
               (:file "general-settings/10-key-event-timeout")))