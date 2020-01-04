module Poetry.Tools exposing (..)

import Element as El exposing (..)
import ViewHelpers exposing (..)
import Browser exposing (Document)



---- MODEL ----


type alias Model =
    { width : Int
    , data : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )


initModel flags =
    { width = flags.width
    , data = flags.data
    }


type alias Flags =
    { width : Int
    , data : String
    }



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


markdownString : String
markdownString =
    """
    # Illi hos tantum templo

    ## Ut ter inquit interdum modo tenendae aestus

    Lorem markdownum arcum Philomela pectine, est portans angulus utque diem, non.
    Primi infamia auctor Adoni. Per leto circumdata ipsa vigilat, tamen omnique
    procul sagittis lumen, orbi.

    - Pro totumque protinus in aegra hasta
    - Apro quamvis
    - Ulla ibat mortis caligine discors harenis habuissem
    - Temeraria balatus
    - Voce Pasiphaen vidit

    ## Ex sextae deae pro quid novissima quoque

    Antiphatae in Achivi suam inplevit, credula sub ferro aliquid increpor ast orbae
    delendaque, flenda memor inque inputet opaca. Fallere segnior et oculis umbra;
    iactant fera vulnera quisque Pelasgi aestus vagae, Neptunus sed. Et quicquam
    uritur: pro quae: curvo creatus nec quae. Est postes de rura, peperisse est a
    aliquisque, niveae ademptae dabantur hippomene matremque. Laborem est morte, et
    vidit: parva in altera gener, unum quam ab ursos montibus nunc!

    Stellantibus dixit incinctus cum amore denique; et etiam meliore inducit cum
    auras fama nunc! Dedit en apta exstabat Alcmene secundum; verumque miserrima
    fecerat, concipit iram siqua, neve? Herba praevisos, ecce Procne a aures fames
    fumida in nocuit latentem matri.

    ## Caelestesque sedare est pereunt undis

    Umbram ille arida monstro et carmine indice, languere nulla mihi deo elisarum
    quid mellaque iacent, mihi. Quamvis tu inrequieta Clanis experientis omnia,
    matri conspectos medios urguet flecti simul! Venenis ripas in genitor pars, et
    levavit mi vultus plebe interceperit verba dissaepserat Cephalum. Dixit me onus
    video duorum, suo equis ignibus lapsa regia corpore e vestrae usus dedecus.

    Permiscuit atque corripuit et teque putando collo minari natura ornata
    penetralia in procul Iove. Non ora, effudit turpe gemitus recentibus atria
    meminisse extinctum Scyllae et dextera resolvit tamen urbes. Cipus figuras.
    """


view : Model -> Browser.Document msg
view model =
    markdownPageHelper (findScreenSize model.width) "POETRY TOOLS" markdownString
