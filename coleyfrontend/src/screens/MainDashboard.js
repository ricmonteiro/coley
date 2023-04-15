import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios'
import { useState, useEffect } from 'react'



function MainDashboard() {
  const [error, setError] = useState("");
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const navigate = useNavigate();

  const handleLogout = () => {
    axios.post('/logout/')
    .then((response) => {
      if (response.data.success) {
        navigate('/');
      } else {
        setError(response.data.error);
      }
    })
  }



  return (
    <div className='dash'>
      <h1>MainDashboard</h1>
      {selectedRole && <p>Role: {selectedRole}</p>}
      <button className='role-selection-buttons button' style={{ backgroundColor: "black" }} onClick={handleLogout}>Logout</button>
      {selectedRole == 'Admin' && <button className='role-selection-buttons button' >Create new user</button>}


    </div>
  );
};

export default MainDashboard;