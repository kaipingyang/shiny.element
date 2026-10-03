# Let go of an upload job a failed or aborted file left behind

Shiny keeps an upload job until `uploadEnd` finishes it, and finishing
one with files still to come is an error. A batch with a failed or
aborted file is sent again as a new job, so the old one would wait in
the session until it ended, with whatever part of a file reached its
directory. The browser names it here and it is removed: dropped from the
session's upload jobs and its directory deleted. Shiny offers no public
way to do this, so the session's upload context is reached into; should
that change, the job is left as before, to go when the session does.

## Usage

``` r
.el_upload_abandon(job_id, session)
```

## Arguments

- job_id:

  The job's id, from `uploadInit`.

- session:

  The Shiny session the job belongs to.

## Value

Whether the job was found and removed, invisibly.
