import React from 'react'
import Button from 'react-bootstrap/Button';
import axios from 'axios';
import { useEffect, useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Row, Col, Form, FormGroup, Modal} from "react-bootstrap";

function GetResults() {
    const [selectedFilter, setSelectedFilter] = useState('')
    const [error, setError] = useState('')
    const location = useLocation();
    const navigate = useNavigate();
    const [show, setShow] = useState(false);

    const handleClose = () => setShow(false);
    const handleShow = () => setShow(true);

    const isLogged = location.state && location.state.isLogged;
    const authUser = location.state && location.state.authUser;
    const selectedRole = location.state && location.state.selectedRole;


    useEffect(() => {
        if(!isLogged){
          navigate('/')}});


    
    const handleFilterSelection = (event) => {
           setSelectedFilter(event.target.value); 
           console.log(selectedFilter)   
    };
    
    const handleSubmit = (event) => {
        console.log(selectedFilter)
    }


    const handleCancel = (event) => {
        console.log(isLogged)
        navigate('/dashboard', { state : { isLogged, selectedRole, authUser }})
      }




  return (
    <Form onSubmit={handleSubmit}>
        <h2>Get results by user or sample</h2><h1>         
        
        </h1>

        <h3>Filter by:</h3>
        <FormGroup>

        {["User", "Sample"].map((filter) => (
            
        <div key={filter} >  

            <Form.Label key={filter} htmlFor={filter}>    
          {filter}</Form.Label>
        
          <Col>
            <Form.Check
              key={filter}
              className="role-selection-option label"
              type="radio"
              id={filter}
              name="filter"
              value={filter}
              checked={selectedFilter === filter}
              onChange={handleFilterSelection} />   
          </Col>

        </div>  
        
          
      ))}</FormGroup>
        <Button className='button m-2' style={{ backgroundColor: "blue" }} disabled={!selectedFilter} onClick={handleShow}>Get results</Button>
        <Button  className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>

        
      <Modal show={show} onHide={handleClose}>
        <Col>
        <Modal.Header closeButton>
          <Modal.Title>Filter by {selectedFilter}</Modal.Title>
        </Modal.Header>
        <Modal.Body>Select {selectedFilter}:</Modal.Body>
        </Col>
        <Col>
        <Modal.Footer>
         
          <Button variant="primary" onClick={handleClose}>
            Get results
          </Button>

          <Button variant="secondary" onClick={handleClose}>
            Close
          </Button>
        </Modal.Footer>
        </Col>
      </Modal>



        
    </Form>
  )
}

export default GetResults