import React, { useEffect, useState } from "react";
import axios from "axios";
import { useNavigate, useLocation } from "react-router-dom";


function SelectRoles() {
  const [roles, setRoles] = useState([]);
  const [selectedRole, setSelectedRole] = useState(null);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false)
  const location = useLocation();
  const isLogged = location.state && location.state.isLogged;
  const navigate = useNavigate();

  useEffect(() => {
    if(isLogged){
    setLoading(true)
    axios.get("/user_roles/")
    .then((response) => {
      setRoles(response.data[0]);
      setLoading(false)}
    )
    .catch((error) => {
      console.error(error);
      setError("An error occurred while retrieving the available roles");
    });
  }else{navigate('/')}}, [navigate, isLogged, selectedRole]);


  const handleRoleSelection = (event) => {
      setSelectedRole(event.target.value);    
  };

  const handleBack = () => {
    setError(null);
    if (isLogged){
      navigate('/')
    }else{
    axios.post('/logout/')
    .then((response) => {
      if (response.data.success) {
        navigate('/');
      } else {
        setError(response.data.error);
      }
    })}
  }

  const handleSubmit = (event) => {
    event.preventDefault();
    navigate('/dashboard', { state:{ selectedRole, isLogged } });
  };

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
      <ul>{roles.map((role) => (
        <div key={role.role_id}>
          <input className="role-selection-option label"
            type="radio"
            id={role.role}
            name="role"
            value={role.role}
            checked={selectedRole === role.role}
            onChange={handleRoleSelection} />
          <label htmlFor={role.role}>    
          {role.role}</label>
        </div>       
      ))}</ul>

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