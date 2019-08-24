import ./make-test.nix ({ pkgs, ... }: {
  name = "jormungandr";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mmahut ];
  };

  nodes = {
    bft = { ... }: {
      environment.systemPackages = [ pkgs.jormungandr ];

      services.jormungandr.enable = true;
      services.jormungandr.genesisBlockFile = "/var/lib/jormungandr/block-0.bin";
      services.jormungandr.secretFile = "/etc/secrets/jormungandr.yaml";
    };
  };

  testScript = ''
    startAll;

    # Let's wait for the StateDirectory
    $bft->waitForFile("/var/lib/jormungandr/");

    # First, we generate the genesis file for our new blockchain
    $bft->succeed("jcli genesis init > /root/genesis.yaml");

    # We need to generate our secret key
    $bft->succeed("jcli key generate --type=Ed25519 > /root/key.prv");

    # We include the secret key into our services.jormungandr.secretFile
    $bft->succeed("mkdir -p /etc/secrets");
    $bft->succeed("echo -e \"bft:\\n signing_key:\" \$(cat /root/key.prv) > /etc/secrets/jormungandr.yaml");

    # After that, we generate our public key from it
    $bft->succeed("cat /root/key.prv | jcli key to-public > /root/key.pub");

    # We add our public key as a consensus leader in the genesis configration file
    $bft->succeed("sed -ie \"s/ed25519_pk1vvwp2s0n5jl5f4xcjurp2e92sj2awehkrydrlas4vgqr7xzt33jsadha32/\$(cat /root/key.pub)/\" /root/genesis.yaml");

    # Now we can generate the genesis block from it
    $bft->succeed("jcli genesis encode --input /root/genesis.yaml --output /var/lib/jormungandr/block-0.bin");

    # We should have everything to start the service now
    $bft->succeed("systemctl restart jormungandr");
    $bft->waitForUnit("jormungandr.service");

    # Now we can test if we are able to reach the REST API
    $bft->waitUntilSucceeds("curl -L http://localhost:8607/api/v0/node/stats | grep uptime");
  '';
})
