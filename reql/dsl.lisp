(in-package :cl-rethinkdb-reql)

(defun query-builder (form)
  "Takes a query form and turns it into a tree of query objects."
  (if (and (listp form)
           (keywordp (car form)))
      (apply 'call
             (car form)
             (mapcar 'query-builder (cdr form)))
      form))

(defmacro r (&body query-form)
  "Wraps query generation in a macro that takes care of pesky function naming
   issues. For instance, the function `count` is reserved in CL, so importing
   cl-rethinkdb-reql:count into your app might mess a lot of things up.
   Instead, you can wrap your queries in (r ...) and use *keywords* for function
   names, and all will be well. For instance:
   
     (r::insert (r::table \"users\") '((\"name\" . \"larry\")))
   
   becomes:
   
     (r (:insert (:table \"users\") '((\"name\" . \"larry\"))))
   
   This allows you to separate CL functions from query functions both logically
   and visually."
  `(query-builder ',query-form))

