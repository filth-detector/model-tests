{
  description = "CUDA development environment";
  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = true;
        config.cudaVersion = "12";
      };
      # Change according to the driver used: stable, beta
      nvidiaPackage = pkgs.linuxPackages.nvidiaPackages.beta;
      ffmpegPackage = pkgs.ffmpeg_7-full;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          glibc_multi
          fmt.dev
          cudaPackages.cuda_cudart
          cudatoolkit
          nvidiaPackage
          cudaPackages.cudnn
          libGLU
          libGL
          libXi
          libXmu
          freeglut
          libXext
          libX11
          libXv
          libXrandr
          zlib
          ncurses
          stdenv.cc
          binutils
          uv
          graphviz
          ffmpegPackage
        ];

        shellHook = ''
          export CUDA_PATH=${pkgs.cudatoolkit}
          export EXTRA_LDFLAGS="-L/lib -L${nvidiaPackage}/lib"
          export EXTRA_CCFLAGS="-I/usr/include"
          export CMAKE_PREFIX_PATH="${pkgs.fmt.dev}:$CMAKE_PREFIX_PATH"
          export PKG_CONFIG_PATH="${pkgs.fmt.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
          export LD_LIBRARY_PATH="${nvidiaPackage}/lib:${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
                    

          exec fish
          . .venv/bin/activate.fish
        '';
      };
    };
}

