Module: dvm
Synopsis: Dylan Environment Configurator
Author: Dan Midwood
Copyright: See LICENSE file in this distribution.

define method candidates-location()
  subdirectory-locator(home-directory(), ".dvm/candidates");
end;

define method bin-location()
  subdirectory-locator(home-directory(), ".dvm/bin");
end;

define method list-versions(candidate :: <string>)
  let candidates-dir = subdirectory-locator(candidates-location(), candidate);
  let candidate-version-dir = subdirectory-locator(candidates-dir, "bin");
  run-application(concatenate("ls ", as(<string>, candidate-version-dir)));
end;

define method list-candidates()
  run-application(concatenate("ls ", as(<string>, candidates-location())));
end;

define method install-candidate(candidate :: <string>, version :: <string>)
  let from-location = subdirectory-locator(working-directory(), "_build");
  let candidate-bin-location = subdirectory-locator(
                                                    subdirectory-locator(candidates-location(), candidate),
                                                    "bin");
  ensure-directories-exist(candidate-bin-location);
  let to-location = subdirectory-locator(candidate-bin-location, version);
  run-application(format-to-string("cp -r %s %s", from-location, to-location));
end;

define generic run-command(cmd :: <symbol>, args :: <list>) => ();

define method run-command(cmd == #"use", args :: <list>) => ()
  let (candidate, version) = apply(values, args);
  let candidates-dir = candidates-location();
  let candidate-bin = subdirectory-locator(candidates-dir, candidate);
  candidate-bin := subdirectory-locator(candidate-bin, "bin");
  candidate-bin := subdirectory-locator(candidate-bin, version);
  candidate-bin := subdirectory-locator(candidate-bin, "bin");
  let bin-dir = bin-location();
  run-application(format-to-string("ln -fs %s %s",
                                   concatenate(as(<string>, candidate-bin), "*"),
                                   bin-dir));
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
  // format-out("unknown cmd: %s", cmd)  --cgay
  format-out("unknown cmd: ");
  format-out(as(<string>, cmd));
end;

define method main (name :: <string>, args :: <list>)
  ensure-directories-exist(candidates-location());
  run-command(as(<symbol>, head(args)), tail(args));
  exit-application(0);
end;

main(application-name(), as(<list>, application-arguments()));
