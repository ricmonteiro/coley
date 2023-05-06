import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios'
import { useEffect } from 'react'
import { Button } from 'react-bootstrap'



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

  const handleRegisterNewPatient = () => {
      const isLogged = true
      navigate('/new_patient', { state: { isLogged, selectedRole } });
      
        }

  return (
    <div className='dash'>
      <h1>Dashboard</h1>
      {<p>Role: {selectedRole}</p>}
      {<p>{isLogged}</p>}
      {selectedRole === 'Admin' && <Button className='button m-2' onClick={handleCreateNewUser}>Create new user</Button>}
      {selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewSample}>Register new sample</Button>}
      {selectedRole !== 'Student' && <Button className='button m-2' onClick={handleRegisterNewPatient}>Register new patient</Button>}
      <Button className='role-selection-buttons button m-2' style={{ backgroundColor: "black" }} onClick={handleLogout}>Logout</Button>


    </div>
  );
};

export default MainDashboard;