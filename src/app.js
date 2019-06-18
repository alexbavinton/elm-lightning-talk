import React from 'react';
import Elm from 'react-elm-components'; 
import Timer from './Main.elm';


const App = () => {

  return (
    <>
      <Elm src={Timer.Elm.Main} />
    </>
  )
} 

export default App;