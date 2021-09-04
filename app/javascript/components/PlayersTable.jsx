import React, { useEffect, useState } from "react"
import axios from "axios"

export function PlayersTable(props) {

  const [loading, setLoading] = useState(false);
  const [requestFailed, setRequestFailed] = useState(true);
  const [players, setPlayers] = useState([]);

  useEffect(() => {
    const fetchPlayers = () => {
      setLoading(true)
      axios
        .get('/players/')
        .then(response => {
          setRequestFailed(false);
          setPlayers(response.data);
        })
        .catch(error => {
          console.log(error)
          setRequestFailed(true);
        })
        .finally(() => setLoading(false))
    }
    fetchPlayers();
  }, [])

  if (loading) {
    return <p>Retrieving latest players...</p>
  }

  if (requestFailed) {
    return <p>Request failed.</p>
  }

  return (
    <div className="players-table">
      <div className="bg-white rounded overflow-scroll md:overflow-hidden border-t border-l border-r border-b border-gray-400 p-4">
        <table className="table-auto md:w-full">
          <caption className="text-xl">Hockey Players</caption>
          <thead>
          <tr>
            <th className="px-4 py-2">First Name</th>
            <th className="px-4 py-2">Last Name</th>
            <th className="px-4 py-2">Position</th>
            <th className="px-4 py-2">Origin Country</th>
          </tr>
          </thead>
          <tbody>
          {players.map(player => (
            <tr key={player.id}>
              <td className="border px-4 py-2">{player.first_name}</td>
              <td className="border px-4 py-2">{player.last_name}</td>
              <td className="border px-4 py-2">{player.position}</td>
              <td className="border px-4 py-2">{player.origin_country}</td>
            </tr>
          ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}

export default PlayersTable