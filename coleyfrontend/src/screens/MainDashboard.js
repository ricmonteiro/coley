import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios'
import { useState, useEffect } from 'react'



function MainDashboard() {
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  const navigate = useNavigate();

  useEffect(() => {
    if(!isLogged){
      navigate('/')}});

  const handleLogout = () => { 
    axios.post('/logout/', {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }})
    .then((response) => {
      if (response.data.success) {
        navigate('/');
      } else {
        navigate('/');;
      }
    })
    
  }

  const handleCreateNewUser = () => {
    const isLogged = true
    navigate('/new_user', { state: { isLogged, selectedRole } });
  
    }

  const handleRegisterNewSample = () => {
      const isLogged = true
      navigate('/new_sample', { state: { isLogged, selectedRole } });
    
      }

  return (
    <div className='dash'>
      <h1>Dashboard</h1>
      {<p>Role: {selectedRole}</p>}
      {<p>{isLogged}</p>}
      {selectedRole === 'Admin' && <button className='button' onClick={handleCreateNewUser}>Create new user</button>}
      {selectedRole !== 'Student' && <button className='button' onClick={handleRegisterNewSample}>Register new sample</button>}
      <button className='role-selection-buttons button' style={{ backgroundColor: "black" }} onClick={handleLogout}>Logout</button>


    </div>
  );
};

export default MainDashboard;