import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios'
import { useState, useEffect } from 'react'



function MainDashboard() {
  const [error, setError] = useState("");
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  const navigate = useNavigate();

  useEffect(() => {
    if(!isLogged){
      navigate('/')}}, []);

  const handleLogout = () => { 
    axios.post('/logout/', {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }})
    .then((response) => {
      if (response.data.success) {
        navigate('/');
      } else {
        setError(response.data.error);
      }
    })
    
  }

  const handleCreateNewUser = () => {
    navigate('/register_new_user');
  
    }

  return (
    <div className='dash'>
      <h1>MainDashboard</h1>
      {<p>Role: {selectedRole}</p>}
      {<p>{isLogged}</p>}
      <button className='role-selection-buttons button' style={{ backgroundColor: "black" }} onClick={handleLogout}>Logout</button>
      {selectedRole === 'Admin' && <button className='role-selection-buttons button' onClick={handleCreateNewUser} >Create new user</button>}


    </div>
  );
};

export default MainDashboard;