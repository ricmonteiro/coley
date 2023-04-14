import React, { useEffect, useState } from "react";
import axios from "axios";

function SelectRoles() {
  const [roles, setRoles] = useState([]);
  const [selectedRole, setSelectedRole] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    axios.get("/user_roles/")
    .then((response) => {
      setRoles(response.data);
    })
    .catch((error) => {
      console.error(error);
      setError("An error occurred while retrieving the available roles");
    });
  }, []);

  const handleRoleSelection = (event) => {
    setSelectedRole(event.target.value);
  };

  return (
    <div className='role-selection'>
      <h2>Select Your Role</h2>
      {error && <p>{error}</p>}
      {roles.map((role) => (
        <div key={role.id}>
          <input
            type="radio"
            id={role.name}
            name="role"
            value={role.id}
            checked={selectedRole === role.id}
            onChange={handleRoleSelection}
          />
          <label htmlFor={role.name}>{role.name}</label>
        </div>
      ))}
      <br />
      <button disabled={!selectedRole}>Continue</button>
    </div>
  );
}

export default SelectRoles;