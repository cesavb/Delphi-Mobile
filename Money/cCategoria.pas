unit cCategoria;

interface

uses FireDAC.comp.Client, FireDAC.DApt, System.SysUtils, FMX.Graphics;

type
   TCategoria = class
      private
         Fconn: TFDConnection;
         FDESCRICAO: string;
         FID_CATEGORIA: INTEGER;
         FICONE: TBitmap;
         FINDICE_ICONE: INTEGER;
      public
         constructor Create(conn: TFDConnection);
         property ID_CATEGORIA: INTEGER read FID_CATEGORIA write FID_CATEGORIA;
         property DESCRICAO: string read FDESCRICAO write FDESCRICAO;
         property ICONE: TBitmap read FICONE write FICONE;
         property INDICE_ICONE: INTEGER read FINDICE_ICONE write FINDICE_ICONE;

         function ListarCategoria(out erro: string): TFDQuery;
         function Inserir(out erro: string): Boolean;
         function Alterar(out erro: string): Boolean;
         function Excluir(out erro: string): Boolean;
   end;

implementation

{ TCategoria }

constructor TCategoria.Create(conn: TFDConnection);
begin
   Fconn := conn;
end;

function TCategoria.Inserir(out erro: string): Boolean;
var
   qry: TFDQuery;
begin
   if DESCRICAO = '' then
   begin
      erro := 'Informe a descrição da categoria';
      Result := false;
      exit;
   end;

   try
      try
         qry            := TFDQuery.Create(nil);
         qry.Connection := Fconn;

         with qry do
         begin
            Active := false;
            SQL.Clear;
            SQL.Add('INSERT INTO TAB_CATEGORIA(DESCRICAO, ICONE, INDICE_ICONE) VALUES (:DESCRICAO, :ICONE, :INDICE_ICONE)');
            ParamByName('DESCRICAO').Value := DESCRICAO;
            ParamByName('ICONE').Assign(ICONE);
            ParamByName('INDICE_ICONE').Value := INDICE_ICONE;
            ExecSQL;
         end;

         Result := true;
         erro   :='';

      except on ex:Exception do
         begin
            Result := false;
            erro   := 'Erro ao consultar categorias: ' + ex.Message;
         end;
      end;

   finally
      qry.DisposeOf;
   end;
end;

function TCategoria.ListarCategoria(out erro: string): TFDQuery;
var
   qry: TFDQuery;
begin
   try
      qry :=TFDQuery.Create(nil);
      qry.Connection := Fconn;

      with qry do
      begin
         active := false;
         sql.Clear;
         sql.Add('SELECT * FROM TAB_CATEGORIA');
         sql.Add('WHERE 1 = 1');

         if ID_CATEGORIA > 0 then
         begin
             SQL.Add('AND ID_CATEGORIA = :ID_CATEGORIA');
             ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
         end;

         sql.Add('ORDER BY DESCRICAO');

         Active := true;
      end;

      Result := qry;
      erro   := '';
   except on ex:exception do
      begin
         Result := nil;
         erro   := 'Erro ao consultar categorias: ' + ex.Message;
      end;
   end;
end;

function TCategoria.Excluir(out erro: string): Boolean;
var
   qry: TFDQuery;
begin
   if ID_Categoria <= 0 then
   begin
      erro := 'Informe o ID da categoria';
      Result := false;
      exit;
   end;

   try
      try
         qry            := TFDQuery.Create(nil);
         qry.Connection := Fconn;

         with qry do
         begin
            Active :=false;
            SQL.Clear;
            SQL.Add('SELECT * FROM TAB_LANCAMENTO');
            SQL.ADD('WHERE ID_CATEGORIA = :ID_CATEGORIA');
            ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
            Active := True;
            //Validar se categoria possiu lançamentos
            if RecordCount > 0 then
            begin
               Result := False;
               erro := 'A categoria possui lançamentos e não pode ser excluída';
               exit;
            end;

            Active := false;
            SQL.Clear;
            SQL.Add('DELETE FROM TAB_CATEGORIA WHERE ID_CATEGORIA = :ID_CATEGORIA');
            ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
            ExecSQL;
         end;

         Result := true;
         erro   :='';

      except on ex:Exception do
         begin
            Result := false;
            erro   := 'Erro ao excluir categorias: ' + ex.Message;
         end;
      end;

   finally
      qry.DisposeOf;
   end;
end;

function TCategoria.Alterar(out erro: string): Boolean;
var
   qry: TFDQuery;
begin
   if ID_Categoria <= 0 then
   begin
      erro := 'Informe a drescrição da categoria';
      Result := false;
      exit;
   end;

   if DESCRICAO = '' then
   begin
      erro := 'Informe a drescrição da categoria';
      Result := false;
      exit;
   end;

   try
      try
         qry            := TFDQuery.Create(nil);
         qry.Connection := Fconn;

         with qry do
         begin
            Active := false;
            SQL.Clear;
            SQL.Add('UPDATE TAB_CATEGORIA SET DESCRICAO = :DESCRICAO, ICONE = :ICONE, INDICE_ICONE = :INDICE_ICONE WHERE ID_CATEGORIA = :ID_CATEGORIA');
            ParamByName('DESCRICAO').Value := DESCRICAO;
            ParamByName('ICONE').Assign(ICONE);
            ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
            ParamByName('INDICE_ICONE').Value := INDICE_ICONE;
            ExecSQL;
         end;

         Result := true;
         erro   :='';

      except on ex:Exception do
         begin
            Result := false;
            erro   := 'Erro ao inserir categorias: ' + ex.Message;
         end;
      end;

   finally
      qry.DisposeOf;
   end;
end;

end.
