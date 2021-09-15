unit UnitSplash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects;

type
  TFrmSplash = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSplash: TFrmSplash;

implementation

{$R *.fmx}

uses UnitLogin;

procedure TFrmSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := TCloseAction.caFree;
   FrmSplash := nil;
end;

procedure TFrmSplash.FormCreate(Sender: TObject);
begin
   Image1.Align := TAlignLayout.Center; //Garantir que a imagem sempre fique no centro do Form sempre.
end;

procedure TFrmSplash.FormShow(Sender: TObject);
begin
   Timer1.Interval := 3000; //Intervalo em milesegundos para começar.
   Timer1.Enabled  := true; //Habilitando o componente Timer
   Image1.Opacity  :=0; //Opacidade 0 para a imagem ficar invisivel.
   Image1.Align    := TAlignLayout.None; //Deixando a imagem sem posicionamento para que aconteça a animação.

   Image1.AnimateFloat('Opacity', 1, 0.5); //Animando a opacidade de 0 para 1 em 0.8 segundos.
   Image1.AnimateFloatDelay('position.Y', 125, 0.5, 0.6, TAnimationType.In, TInterpolationType.Linear);//No terceiro parametro ele informa qual tempo ele vai esperar para executar o comando.
end;

procedure TFrmSplash.Timer1Timer(Sender: TObject);
begin
   Timer1.Enabled := false; //Para o timer para que não fique num looping.

   if not Assigned(FLogin) then
      Application.CreateForm(TFLogin, FLogin);//Crio o Form seguinte.

   Application.MainForm := FLogin;//Passa o MainForm para o Form desejado.
   FrmSplash.Close;//Fecha o Splash.

   FLogin.Show;//Mostra o Form seguinte desejado.
end;

end.
