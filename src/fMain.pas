unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Menus, System.Actions, FMX.ActnList, FMX.StdActns, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects;

type
  TForm1 = class(TForm)
    mmo: TMemo;
    ActionList1: TActionList;
    ToolBar1: TToolBar;
    FileExit1: TFileExit;
    MainMenu1: TMainMenu;
    mnuFichier: TMenuItem;
    mnuFichierQuitter: TMenuItem;
    mnuMac: TMenuItem;
    mnuFichierOuvrir: TMenuItem;
    mnuFichierEnregistrer: TMenuItem;
    mnuFichierSeparateur: TMenuItem;
    btnNouveau: TButton;
    btnOuvrir: TButton;
    btnEnregistrer: TButton;
    btnFermer: TButton;
    svgOuvrir: TPath;
    svgEnregistrer: TPath;
    svgFermer: TPath;
    svgNew: TPath;
    mnuFichierFermer: TMenuItem;
    mnuFichierNouveau: TMenuItem;
    actNouveauFichier: TAction;
    actChargerFichier: TAction;
    actEnregistrerFichier: TAction;
    actFermerFichier: TAction;
    StyleBook1: TStyleBook;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure actNouveauFichierExecute(Sender: TObject);
    procedure actFermerFichierExecute(Sender: TObject);
    procedure actChargerFichierExecute(Sender: TObject);
    procedure actEnregistrerFichierExecute(Sender: TObject);
    procedure mmoChangeTracking(Sender: TObject);
  private
    FNomDuFichierOuvert: string;
    FFichierModifier: boolean;
    procedure SetNomDuFichierOuvert(const Value: string);
    procedure SetFichierModifier(const Value: boolean);
    { Déclarations privées }
  protected
    procedure ChangerTitreDeFenetre;
    property NomDuFichierOuvert: string read FNomDuFichierOuvert
      write SetNomDuFichierOuvert;
    property FichierModifier: boolean read FFichierModifier
      write SetFichierModifier;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.IOUtils;

procedure TForm1.actChargerFichierExecute(Sender: TObject);
begin
  if OpenDialog1.Execute and (OpenDialog1.FileName <> '') and
    tfile.Exists(OpenDialog1.FileName) then
  begin
    NomDuFichierOuvert := OpenDialog1.FileName;
    mmo.Lines.LoadFromFile(NomDuFichierOuvert);
    FichierModifier := false;
  end;
  mmo.SetFocus;
end;

procedure TForm1.actEnregistrerFichierExecute(Sender: TObject);
begin
  if (mmo.Lines.Count < 1) or ((mmo.Lines.Count = 1) and (mmo.Lines[0].isempty))
  then
  begin
    mmo.SetFocus;
    FichierModifier := false;
    exit;
  end;

  if NomDuFichierOuvert.isempty and SaveDialog1.Execute and
    (SaveDialog1.FileName <> '') then
    NomDuFichierOuvert := SaveDialog1.FileName;

  if not NomDuFichierOuvert.isempty then
  begin
    mmo.Lines.SaveToFile(NomDuFichierOuvert, tencoding.UTF8);
    FichierModifier := false;
  end;

  mmo.SetFocus;
end;

procedure TForm1.actFermerFichierExecute(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TForm1.actNouveauFichierExecute(Sender: TObject);
begin
  NomDuFichierOuvert := '';
  mmo.Lines.Clear;
  FichierModifier := false;
  mmo.SetFocus;
end;

procedure TForm1.ChangerTitreDeFenetre;
begin
  caption := TPath.GetFileNameWithoutExtension(FNomDuFichierOuvert);
  if FFichierModifier then
    caption := caption + '(*)';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
{$IF not Defined(MACOS)}
  // tout sauf macOS
  mnuMac.Visible := false;
{$ELSE}
  // sur macOS
  mnuFichierSeparateur.Visible := false;
  mnuFichierQuitter.Visible := false;
{$ENDIF}
  OpenDialog1.InitialDir := TPath.GetDocumentsPath;
  SaveDialog1.InitialDir := TPath.GetDocumentsPath;
  NomDuFichierOuvert := '';

  actFermerFichier.Visible := false;
end;

procedure TForm1.mmoChangeTracking(Sender: TObject);
begin
  if not FFichierModifier then
    FichierModifier := true;
end;

procedure TForm1.SetFichierModifier(const Value: boolean);
begin
  if FFichierModifier <> Value then
  begin
    FFichierModifier := Value;
    ChangerTitreDeFenetre;
  end;
end;

procedure TForm1.SetNomDuFichierOuvert(const Value: string);
begin
  FNomDuFichierOuvert := Value;
  ChangerTitreDeFenetre;
end;

end.
