import React, { useEffect, useState } from "react";
import axios from "axios";
import { useNavigate, useLocation } from "react-router-dom";
import { Button , Row, Col, Form } from 'react-bootstrap'


function SelectRoles() {
  const [roles, setRoles] = useState([]);
  const [selectedRole, setSelectedRole] = useState(null);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false)
  const location = useLocation();
  const isLogged = location.state && location.state.isLogged;
  const authUser = location.state && location.state.authUser;

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
    navigate('/dashboard', { state:{ selectedRole, isLogged, authUser } });
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

    {!loading && <div className='role-selection-form'>
    

    <h2>Select Your Role</h2>
    
      {error && <p>{error}</p>}

     {roles.map((role) => (
      <Row>
        
        <Col>
          
        <Form.Label htmlFor={role.role}>    
          {role.role}</Form.Label>
        
        </Col>

          
        <Col>
          <Form.Check 
            className="role-selection-option label"
            type="radio"
            id={role.role}
            name="role"
            value={role.role}
            checked={selectedRole === role.role}
            onChange={handleRoleSelection} />
        </Col>
            
        </Row>       
      ))}

      </div>}
      <br />    
      <div className="role-selection-buttons">
      <Button className='button m-2' disabled={!selectedRole} onClick={handleSubmit}>Continue</Button>
      <Button className='button m-2' style={{ backgroundColor: "black" }} onClick={handleBack}>Back</Button>
      </div>
      </div>
  );
}

export default SelectRoles;