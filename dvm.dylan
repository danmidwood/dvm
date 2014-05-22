Module: dvm
Synopsis: Dylan Environment Configurator
Author: Dan Midwood
Copyright: See LICENSE file in this distribution.

define method candidates-location()
  let hd = as(<string>, home-directory());
  concatenate(hd, ".dvm/candidates/");
end;

define method bin-location()
  let hd = as(<string>, home-directory());
  concatenate(hd, ".dvm/bin/");
end;

define method list-versions(candidate :: <string>)
  let candidates-dir = candidates-location();
  working-directory-setter(candidates-dir);
  run-application(concatenate("ls ", candidate, "/bin"));
end;

define method list-candidates()
  let candidates-dir = candidates-location();
  working-directory-setter(candidates-dir);
  run-application("ls ");
end;

define method install-candidate(candidate :: <string>, version :: <string>)
  let from-location = concatenate(as(<string>, working-directory()), "_build");
  let candidate-bin-location = concatenate(as(<string>, candidates-location()), candidate, "/bin/");
  ensure-directories-exist(candidate-bin-location);
  let to-location = concatenate(candidate-bin-location, version);
  run-application(concatenate("cp -r \"", from-location, "\" \"", to-location, "\""));
end;

define generic run-command(cmd :: <symbol>, args :: <list>) => ();

define method run-command(cmd == #"use", args :: <list>) => ()
  let candidate = first(args);
  let version = second(args);
  let candidates-dir = candidates-location();
  let candidate-bin = concatenate(candidates-dir, candidate, "/bin/", version, "/bin/");
  let bin-dir = bin-location();
  run-application(concatenate("ln -fs ", concatenate(candidate-bin, "*"), " ", bin-dir));
end;

define method run-command(cmd == #"install", args :: <list>) => ()
  let candidate = first(args);
  install-candidate(candidate,second(args));
end;

define method run-command(cmd == #"list", args :: <list>) => ()
  if (size(args) > 0)
    list-versions(head(args));
  else
    list-candidates();
  end;
end;

define method run-command(cmd :: <symbol>, args :: <list>) => ()
  format-out("unknown cmd: ");
  format-out(as(<string>, cmd));
end;

define method main (name :: <string>, args :: <list>)
  ensure-directories-exist(candidates-location());
  run-command(as(<symbol>, head(args)), tail(args));
  exit-application(0);
end;

main(application-name(), as(<list>, application-arguments()));
