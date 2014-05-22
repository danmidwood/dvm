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
  use file-system;
  use format-out;
end module dvm;
