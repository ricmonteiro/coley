import React, { useEffect, useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";


function SelectRoles() {
  const [roles, setRoles] = useState([]);
  const [selectedRole, setSelectedRole] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();


  useEffect(() => {
    axios.get("/user_roles/")
    .then((response) => {
      console.log(response.data)
      setRoles(response.data[0]);
    })
    .catch((error) => {
      console.error(error);
      setError("An error occurred while retrieving the available roles");
    });
  }, []);

  const handleRoleSelection = (event) => {
    setSelectedRole(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    navigate('/dashboard', {state:{ selectedRole }});
  };

  const handleBack = () => {
    setError(null);
    navigate('/');
  }

  if (error) {
    return (
      <div className='role-selection'>
        <p>Error: {error}</p>
        <button onClick={handleBack}>Back</button>
      </div>
    );
  }
  return (
    <div className="role-selection-container ">
    
    <div className='role-selection-form'>
    
      <h2>Select Your Role</h2>
      {error && <p>{error}</p>}
      {roles.map((role) => (
        <div key={role.role_id}>
          <input className="role-selection-option label"
            type="radio"
            id={role.role}
            name="role"
            value={role.role}
            checked={selectedRole === role.id}
            onChange={handleRoleSelection} />

          <label htmlFor={role.role}>
          
          {role.role}</label>

        </div>
        
      ))}
      
      </div>

      <br />    
      <div className="role-selection-buttons">
      <button className='role-selection-buttons button' disabled={!selectedRole} onClick={handleSubmit}>Continue</button>
      <button className='role-selection-buttons button' style={{ backgroundColor: "black" }} onClick={handleBack}>Back</button>
      </div>
      
      </div>
  );
}

export default SelectRoles;