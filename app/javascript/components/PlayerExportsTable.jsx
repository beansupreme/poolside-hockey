import React, { useEffect, useState } from "react"
import axios from "axios"

export function PlayerExportsTable() {

  const [loading, setLoading] = useState(false);
  const [requestFailed, setRequestFailed] = useState(false);
  const [playerExports, setPlayerExports] = useState([]);

  useEffect(() => {
    const fetchPlayerExports = () => {
      setLoading(true);
      axios
        .get('/player_exports/')
        .then(response => {
          setRequestFailed(false);
          setPlayerExports(response.data);
        })
        .catch(error => {
          console.log(error)
          setRequestFailed(true);
        })
        .finally(() => setLoading(false))
    }
    fetchPlayerExports();
  }, [])

  if (loading) {
    return <p>Retrieving latest players exports...</p>
  }

  if (requestFailed) {
    return <p>Failed to retrieve players exports</p>
  }

  return (
    <div className="players-export-table my-8">
      <div className="bg-white rounded overflow-scroll md:overflow-hidden border-t border-l border-r border-b border-gray-400 p-4 ">
        <table className="table-auto md:w-full">
          <caption className="text-xl">Players Exports</caption>
          <thead>
            <tr>
              <th className="px-4 py-2">Time</th>
              <th className="px-4 py-2">File</th>
            </tr>
          </thead>
          <tbody>
            {playerExports.map(playerExport => (
              <tr key={playerExport.id}>
                <td className="border px-4 py-2">{playerExport.created_at}</td>
                <td className="border px-4 py-2">
                  <a href={playerExport.export_url}>Download</a>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}

PlayerExportsTable.propTypes = {};