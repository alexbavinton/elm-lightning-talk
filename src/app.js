import React, {useState, useEffect} from 'react';
import Elm from 'react-elm-components'; 
import axios from 'axios';
import Timer from './Main.elm';
import './styles.css';


const App = () => {
  const [isDone, setDone] = useState(false);
  const [quote, setQuote] = useState('Done!');

  const setupPorts = (ports) => {
    ports.done.subscribe((done) => {
      setDone(done);
    })
  }


  piojopjol ihoihoh 
  useEffect(() => {
    const getQuote = async () => {
      const { data } = await axios.get('http://quotes.rest/qod.json?category=inspire'); 
      const {quote, author} = data.contents.quotes[0];
      setQuote(`${quote} - ${author}`); 
    }
    getQuote();
  }, []);

  return (
    <div className="root">
      {
        isDone ? <div>{quote}</div> : <Elm src={Timer.Elm.Main} ports={setupPorts} />
      }
      
    </div>
  )
} 

export default App;