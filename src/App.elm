module App exposing (..)

import Html exposing (Html, text, div, img, button, br)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Svg exposing (svg,polygon,rect,line)
import Svg.Attributes exposing (viewBox,width,fill,stroke,x1,y1,x2,y2)
import Time exposing (Time,second)
import Animation exposing (px)

import Hexagon exposing (..)

type alias Model =
    { message : String
    , c : Time
    , style : Animation.State
    }

init : String -> ( Model, Cmd Msg )
init path =
    ( { message = "We in here."
      -- path is from the js file
      -- , logo = path
      , c = 0
      , style = 
        Animation.style []
          -- [ Animation.left (px 0.0)
          -- , Animation.opacity 1.0
          -- ]
      }
    , Cmd.none
    )

type Msg
    = Tick Time
    | StartOver
    | Animate Animation.Msg
    | Show

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
  Tick nc ->
    ( { model | c = nc }
    , Cmd.none
    )
  StartOver ->
    ( { model | c = 0 }
    , Cmd.none
    )
  -- time
  Animate amsg ->
    ( { model | style = Animation.update amsg model.style }
    , Cmd.none
    )
  -- specific animations and how u want them
  Show ->
    let 
      newStyle = 
        Animation.interrupt
                   [ Animation.to
                       [ Animation.fill "#FCFCFC" ]
                   , Animation.to
                       [ Animation.fill "#ABE7FF"]
                   ]
                   -- [ Animation.to 
                   --     [ Animation.left (px 0.0)
                   --     , Animation.opacity 0.25
                   --     ]
                   -- , Animation.to 
                   --     [ Animation.left (px 0.0)
                   --     , Animation.opacity 2.0
                   --     ]
                   -- ]
        model.style
    in
      ({ model | style = newStyle }
      , Cmd.none
      )

      
view : Model -> Html Msg
view model =
  -- for the hands of the clock.. making sure time is working
  let 
    angle =
      turns (Time.inMinutes model.c)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
    -- @TODO: fades?
    div [] 
      [ br [] []
      , div []
          -- (List.concat
          --    [ Animation.render model.style
          --    , [ Html.Attributes.style
          --          [ ( "position", "centered" )
          --          , ( "border-style", "none" )
          --          ]
          --      ]
          --    ]
          -- )
          [ text model.message ]
      , br [] []
      , svg [ viewBox "0 0 100 100", width "450px" ]
          -- svgHexagon : List (Attribute msg) -> Hexagon -> Svg msg
          -- hex : Point -> vert rot -> size
      [ svgHexagon [ fill "#7BACFF" ] <| hex (p 50 50) 0 50
      -- animate this one
      , svgHexagon
          (List.concat
             [ Animation.render model.style
             , [ Html.Attributes.style
                   -- CSS attrs to animate
                   [ ( "fill", "#ABE7FF" ) ]
               ]
             ]
          )
          <| hex (p 50 50) 0 49 
      , svgHexagon [ fill "#7BACFF" ] <| hex (p 50 50) 0 31
      , svgHexagon [ fill "#ffffff" ] <| hex (p 50 50) 0 30
      , line [ x1 "49", y1 "49", x2 handX, y2 handY, stroke "#E40618" ] []
      , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#FCFCFC" ] []
      , line [ x1 "51", y1 "51", x2 handX, y2 handY, stroke "#E40618" ] []             
      , svgHexagon [ fill "#E40618" ] <| hex (p 50 50) 0 2
      , svgHexagon [ fill "#FCFCFC" ] <| hex (p 50 50) 0 1.5
      ]
      , div []
          [ button
              [ onClick StartOver
              , onClick Show
              ]
              [ text "blip blip" ]
          ]
      ]

-- animation and ticking is handled here
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
       [ Time.every second Tick
       , Animation.subscription Animate [ model.style ]
       ]
        
