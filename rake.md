in console:
===========

Rake.application.load_task

Rake::Take["something:somewhere"].invoke(1,2,3)

rails something:somewhere[1,2,3]

```
desc "... with params ..."
task :somewhere, [a,b,c] => [:environment] do
  ...
end

desc "... no param ..."
task somewhere: :environment do
  ...
end
```
