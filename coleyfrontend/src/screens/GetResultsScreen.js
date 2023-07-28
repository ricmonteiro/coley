import React from 'react'
import Button from 'react-bootstrap/Button';
import axios from 'axios';
import { useEffect, useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Row, Col, Form, FormGroup} from "react-bootstrap";

function GetResults() {
    const [results, setResults] = useState([])
    const [selectedFilter, setSelectedFilter] = useState([])
    const [error, setError] = useState('')
    const location = useLocation();
    const navigate = useNavigate();

    const isLogged = location.state && location.state.isLogged;
    const authUser = location.state && location.state.authUser;
    const selectedRole = location.state && location.state.selectedRole;


    useEffect(() => {
        if(!isLogged){
          navigate('/')}});


    
    const handleFilterSelection = (event) => {
           setSelectedFilter(event.target.value);    
    };
    
    const handleGetResults = () => {

    axios.get("/get_results_filter/")
    .then((response) => {
      setResults(response.data[0]);}
    )
    .catch((error) => {
      console.error(error);
      setError("An error occurred while retrieving the result files");
    });
  }


    const handleSubmit = (event) => {

        axios.post()

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
            
        <div inline>  

            <Form.Label inline htmlFor={filter}>    
          {filter}</Form.Label>
        

          <Form.Check
            inline
            type="radio"
            name="role"
            value={filter}
            checked={setSelectedFilter === filter}
            onChange={handleFilterSelection} />   

        </div>  
        
          
      ))}</FormGroup>
        <Button className='button m-2' style={{ backgroundColor: "blue" }} type="submit">Get results</Button>
        <Button  className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>



        
    </Form>
  )
}

export default GetResults