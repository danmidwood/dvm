Module: dylan-user

define library dvm
  use common-dylan;
  use io;
  use system;


  export dvm;
end library dvm;

define module dvm
  use common-dylan, exclude: { format-to-string };
  use operating-system;
  use locators-internals;
  use file-system;
  use format-out;
  use format;
end module dvm;
