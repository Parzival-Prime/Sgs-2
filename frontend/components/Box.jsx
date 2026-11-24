"use client"
import { useState, useEffect } from "react"

export default function Box() {
    const [users, setUsers] = useState([])
    const [userName, setUserName] = useState("")

    async function handleSubmit() {
        const res = await fetch(`/api/users`,
            {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    "name": userName
                })
            }
        )

        await fetchUsers()
    }

    async function fetchUsers() {
        const res = await fetch(`/api/users`)
        const data = await res.json()
        console.log(data)
        setUsers(data)
    }

    useEffect(() => {
        fetchUsers()
    }, [])
    return (
        <div
            className="flex justify-between items-center h-full w-full"
        >
            <div className="border border-neutral rounded-md w-[60%] h-50 p-4 flex flex-col justify-between">
                <h2 className="text-xl">Create a User</h2>
                <div className="h-[60%]">
                    <input
                        type="text"
                        placeholder="Enter your name"
                        value={userName}
                        onChange={(e) => setUserName(e.target.value)}
                        className="m-2 border border-white rounded-md p-1"
                    />
                    <button
                        className="border border-neutral h-8 w-25 rounded-md"
                        onClick={handleSubmit}
                    >
                        Submit
                    </button>
                </div>
            </div>

            <div
                className="h-100 w-60 border border-neutral rounded-md flex flex-col items-center py-4"
            >
                <div>List of All Users</div>
                <div className="w-full border border-neutral-600 my-2"></div>
                {users.length !== 0 ?
                    (<div className="flex flex-col justify-center gap-2 w-full">
                        {users.map((user, idx) => (
                            <div key={user.id} className="text-white border border-neutral-700 rounded-sm p-1 flex justify-between px-3 mx-1">
                                <div>{user.name}</div>
                                <div className="text-red-600">Del</div>
                            </div>
                        ))
                        }
                    </div>) :
                    (<div>No users yet</div>)}
            </div>
        </div>
    )
}
