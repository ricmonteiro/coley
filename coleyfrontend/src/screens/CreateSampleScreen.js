import React from 'react'

import { useNavigate, useLocation } from 'react-router-dom';
import { useState, useEffect } from 'react';





function CreateSample() {
  const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  
  useEffect(() => {
    if(!isLogged){
      navigate('/')}});

    
      return (
        <div>
          <h1>Create New Sample</h1>
          
        </div>
      );
}

export default CreateSample