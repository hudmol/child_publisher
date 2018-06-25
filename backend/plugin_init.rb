
ChildPublishing.add_filter(Note.exclude{Sequel.like(:notes, '%"type":"otherfindaid"%') & Sequel.like(:notes, '%"content":"https://preservica.library.yale.edu%')})

ArchivalObject.include(ChildPublisher)
