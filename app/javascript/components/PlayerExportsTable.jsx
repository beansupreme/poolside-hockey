import React, { useEffect, useState } from "react"
import axios from "axios"
import ActionCable from 'actioncable';
import { useAlert } from 'react-alert';
 
const cable = ActionCable.createConsumer('ws://localhost:3000/cable');

 
export function PlayerExportsTable() {
  const alert = useAlert();
  const [loading, setLoading] = useState(false);
  const [requestFailed, setRequestFailed] = useState(false);
  const [playerExports, setPlayerExports] = useState([]);
  // hard-code currentUserId until we have login system in place
  const currentUserId = 1;

  useEffect(() => {

    cable.subscriptions.create({
      channel: 'ExportChannel',
      user_id: currentUserId
    },
    {
      connected: function() {
        console.log('Connected via useEffect hook');
      },
      received: function(subscriptionData) {
        const subscriptionAction = subscriptionData.action;
        if (subscriptionAction === 'export_complete') {
          const newExport = subscriptionData.data;
          setPlayerExports(array => [...array, newExport]);
        }

        if (subscriptionAction === 'error') {
          alert.show('There was an error generating the report. Please try again in a few minutes.');
        }
      }
    }, [cable.subscriptions]);

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
          alert.show('There was an error fetching exports. Please try again later.')
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
          <caption className="text-xl">Player Exports</caption>
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