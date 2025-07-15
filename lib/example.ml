let objects =
  [ ( 1,
      Pdf.Dictionary
        [ ("/Type", Pdf.Name "/Page");
          ("/Parent", Pdf.Indirect 3);
          ( "/Resources",
            Pdf.Dictionary
              [ ( "/Font",
                  Pdf.Dictionary
                    [ ( "/F0",
                        Pdf.Dictionary
                          [ ("/Type", Pdf.Name "/Font");
                            ("/Subtype", Pdf.Name "/Type1");
                            ( "/Basefont",
                              Pdf.Name "/Times-Italic" )
                          ] )
                    ] )
              ] );
          ( "/MediaBox",
            Pdf.Array
              [ Pdf.Float 0.;
                Pdf.Float 0.;
                Pdf.Float 595.275590551;
                Pdf.Float 841.88976378
              ] );
          ("/Rotate", Pdf.Integer 0);
          ("/Contents", Pdf.Array [ Pdf.Indirect 4 ])
        ] );
    ( 2,
      Pdf.Dictionary
        [ ("/Type", Pdf.Name "/Catalog");
          ("/Pages", Pdf.Indirect 3)
        ] );
    ( 3,
      Pdf.Dictionary
        [ ("/Type", Pdf.Name "/Pages");
          ("/Kids", Pdf.Array [ Pdf.Indirect 1 ])
        ] );
    ( 4,
      Pdf.Stream
        ( Pdf.Dictionary [ ("/Length", Pdf.Integer 53) ],
          "1 0 0 1 50 770 cm BT /F0 36 Tf (Hello, world!) \
           Tj ET" ) )
  ]

let hello =
  { Pdf.version = (1, 1);
    Pdf.objects;
    Pdf.trailer =
      Pdf.Dictionary
        [ ("/Size", Pdf.Integer 5);
          ("/Root", Pdf.Indirect 2)
        ]
  }

module Exercise2 = struct
  let a = Pdf.Name "/Name"
  let b = Pdf.String "Quartz Crystal"

  let c =
    Pdf.Dictionary
      [ ("/Type", Pdf.Name "/ObjStm");
        ("/N", Pdf.Integer 100);
        ("/First", Pdf.Integer 807);
        ("/Length", Pdf.Integer 1836);
        ("/Filter", Pdf.Name "/FlatDecode")
      ]

  let d =
    Pdf.Array
      [ Pdf.Integer 1;
        Pdf.Integer 2;
        Pdf.Float 1.5;
        Pdf.String "black"
      ]
end
