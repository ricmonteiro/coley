import React from 'react'
import Button from 'react-bootstrap/Button';
import axios, { AxiosHeaders } from 'axios';
import { useEffect, useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Row, Col, Form, FormGroup, Modal, Table} from "react-bootstrap";

function GetResults() {
    const [selectedFilter, setSelectedFilter] = useState('')
    const [error, setError] = useState('')
    const location = useLocation();
    const navigate = useNavigate();
    const [show, setShow] = useState(false);
    const [showResults, setShowResults] = useState(false);

    const [ users, setUsers] = useState([])

    const handleClose = () => {
      setShow(false);
      setShowResults(false);
    }


    const handleShow = () => {
      setShow(true);


      {/* Get user list. If user is admin/supervisor, get all users. If not, get only the user itself*/}
      axios.get('get_users/')
      .then((response) => {
        console.log(response.data)}
      )
      .catch((error) => {
        console.error(error);
        setError("An error occurred while retrieving the users");
      });
    
    }
      

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
        navigate('/dashboard', { state : { isLogged, selectedRole, authUser }})
      }

    const handleGetResults = (event) => {
      console.log('Results exposed!')
      setShowResults(true)
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

        


        {/*MODAL WITH FILTER AND RESULT LIST FOR DOWNLOAD*/}

      <Modal show={show} onHide={handleClose}>
        <Col>
        <Modal.Header closeButton>
          <Modal.Title>Filter by {selectedFilter}</Modal.Title>
        </Modal.Header>
        <Modal.Body>Select {selectedFilter}:</Modal.Body>
        </Col>
        {users.map((user) => (
        
        <Row>{user}</Row> ))}
        
        <Col>
        <Modal.Footer>
         
        <Button variant="primary" onClick={handleGetResults}>
            Get results
        </Button>

        <Button variant="secondary" onClick={handleClose}>
            Close
        </Button>
        </Modal.Footer>
        </Col>
        <Col>
        <Table show={showResults == false}>
        <thead>
        <tr>
          <th>Result file list</th>
          <th>ID</th>
          <th>Tumor</th>
          <th>Tissue</th>
          <th>Purpose</th>
          <th>User</th>
        </tr>
        </thead>
        <tbody>
        <tr>

          <td>#</td>
          <td>1</td>
          <td>Lung</td>
          <td>Brachiocephalic vein</td>
          <td>TNF-alfa</td>
          <td>Markus</td>
          <td><a href="">&#x21E9;</a></td>
          
        </tr>
        </tbody>
      </Table>
        </Col>
      </Modal>
       
    </Form>
  )
}

export default GetResults