type pdfobject =
  | Boolean of bool
  | Integer of int
  | Float of float
  | String of string
  | Name of string
  | Array of pdfobject list
  | Dictionary of (string * pdfobject) list
  | Stream of pdfobject * string
  | Indirect of int

type t =
  { version : int * int;
    objects : (int * pdfobject) list;
    trailer : pdfobject
  }

let write_header o { version = major, minor } =
  output_string o
    (Printf.sprintf "%%PDF-%i.%i\n" major minor)

let rec string_of_array a =
  let b = Buffer.create 100 in
  Buffer.add_string b "[" ;
  List.iter
    (fun s ->
      Buffer.add_char b ' ' ;
      Buffer.add_string b (string_of_pdfobject s) )
    a ;
  Buffer.add_string b " ]" ;
  Buffer.contents b

and string_of_dictionary d =
  let b = Buffer.create 100 in
  Buffer.add_string b "<<" ;
  List.iter
    (fun (k, v) ->
      Buffer.add_char b ' ' ;
      Buffer.add_string b k ;
      Buffer.add_char b ' ' ;
      Buffer.add_string b (string_of_pdfobject v) )
    d ;
  Buffer.add_string b " >>" ;
  Buffer.contents b

and string_of_stream dict data =
  let b = Buffer.create 100 in
  List.iter
    (Buffer.add_string b)
    [ string_of_pdfobject dict;
      "\nstream\n";
      data;
      "\nendstream"
    ] ;
  Buffer.contents b

and string_of_pdfobject = function
  | Boolean b -> string_of_bool b
  | Integer i -> string_of_int i
  | Float f -> string_of_float f
  | String s -> "(" ^ s ^ ")"
  | Name n -> n
  | Array a -> string_of_array a
  | Dictionary d -> string_of_dictionary d
  | Stream (dict, data) -> string_of_stream dict data
  | Indirect i -> Printf.sprintf "%i 0 R" i

let write_objects o objs =
  let offsets = ref [] in
  List.iter
    (fun (objnum, obj) ->
      offsets := pos_out o :: !offsets ;
      output_string o (Printf.sprintf "%i 0 obj\n" objnum) ;
      output_string o (string_of_pdfobject obj) ;
      output_string o "\nendobj\n" )
    (List.sort objs) ;
  List.rev !offsets
