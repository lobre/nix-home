{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;

    users.lobre = {
      isNormalUser = true;
      home = "/home/lobre";
      createHome = true;
      description = "Loric Brevet";
      uid = 1000;
      shell = pkgs.bash;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ];

      hashedPassword = "$6$cU4UOU9.q$AgVYQJ0LL6nePLMMbI26TDONOd..gbMdDHi1dhnete21UYs.QdSEDYpGElD1MBoRCDmuIwvCJF9UJb/bmT6971";
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGn/ptkzUBO9bvjMi7Ts7DK5O5T+X2TgD5pLMyMclsdj2ls639o3nL7hXDORxxlvmbqCeeXeYJzAo1cskg4PqIOnJY5QUbF9Q9BmVAPaWDpFR+KgvC2uQmABPZJpaZQzbPkLYB6EqT7WcALuWPgQcFOBySivU2ZBtDEyUeJV5l8f6WvXAlY7xCkN+VeaTB659k7wXty78jyVt8ev9aYe9K7xq0gNZxk5Q2r/Ex+wN/rjmPDZHE4Co6ztVQ1NVf49/XQ0GfT0fjJ8C3cE8v4vnpBFgXE4/lZJlrMdh8Oa5c8Ou0W5pbVJhNUWNl8SLUAe6AVeQWY2rC1gfSXjGFQ6W92TCHgX4qst27AeXiVTFHdcoi3WKVN8fWMUYeyyK5dBrDlGwItEwDVtwh8ItFk204xlSnGpMmr9U/nOeJKvsemTpoFjDNPgLl5QU1wHH3ov4/RGtk2ZvNj7l/7bI2Kn8aokbIv0/SOuTpLe7Un3FYNy7VF3+wtTcDxCJ/1jIxNuL47VYBYcRqxz8vjNdQSIKJcyF/bOBOq3QoFLLQeoi73H2f8/Kti6lfDlBg8gNtlkXkXfbdbQMWGsdIkpey4wQqSsKNhhjMC4ELPTJqXzopFIuIVu1hUhAo7VUZz3WJ+WMKbjX/8v5VzgnlBhUeHXkQoH05MRa2iYaDjsAuQdcJaQ== openpgp:0x241822E3" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
