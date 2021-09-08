import React, { useState } from "react";
import { PlayerExportsTable } from "./PlayerExportsTable";
import PlayersTable from "./PlayersTable";
import axios from "axios";
import { transitions, positions, Provider as AlertProvider } from 'react-alert'
import AlertTemplate from 'react-alert-template-basic';

const options = {
  position: positions.MIDDLE,
  timeout: 5000,
  offset: '50px',
  transition: transitions.FADE
}


export function PlayersContainer(props) {

  const [requestRunning, setRequestRunning] = useState(false);
  const [requestFailed, setRequestFailed] = useState(false);

  const createPlayerExport = () => {
    setRequestRunning(true);
    axios
      .post('/player_exports')
      .then(response => {
        setRequestRunning(false);
      })
      .catch(error => {
        console.log(error)
        setRequestFailed(false);
        setRequestRunning(false);
      })
  }

  return (
    <AlertProvider template={AlertTemplate} {...options}>
      <div id="players-container" className="container px-10 mx-auto">
        <PlayersTable/>
        <PlayerExportsTable />
        
        <div className="text-center">  
          <button onClick={() => createPlayerExport()} className={`text-lg text-center text-white font-semibold rounded-full px-4 py-2 leading-normal border border-purple bg-pink-500 hover:bg-pink-600 ${requestRunning ? "cursor-not-allowed" : ""}`}>
            {`${requestRunning ? "Building Export..." : "Create new export"}`}
          </button>
        </div>
      </div>
    </AlertProvider>
  )
}

export default PlayersContainer