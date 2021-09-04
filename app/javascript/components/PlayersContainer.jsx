import React from "react";
import { PlayerExportsTable } from "./PlayerExportsTable";
import PlayersTable from "./PlayersTable";


export function PlayersContainer(props) {

  return (
    <div id="players-container" className="container px-10 mx-auto">
      <PlayersTable/>
      <PlayerExportsTable />
    </div>
  )
}

export default PlayersContainer