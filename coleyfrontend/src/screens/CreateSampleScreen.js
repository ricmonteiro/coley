import React from 'react'

import { useNavigate, useLocation } from 'react-router-dom';
import { useState, useEffect } from 'react';
import { Form, Button, Row, Col} from 'react-bootstrap'





function CreateSample() {
  const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  
  useEffect(() => {
    if(!isLogged){
      navigate('/')}});

    
      return (
        <Form>
          <Form.Label>Create New Sample</Form.Label>
          
        </Form>
      );
}

export default CreateSample