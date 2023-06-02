import React, { useState, useEffect } from 'react'
import axios from 'axios'
import { Container, Button } from 'react-bootstrap'
import { useNavigate, useLocation } from 'react-router-dom'

function SamplesAndCuts() {
    const [availableCuts, setAvailableCuts] = useState([])
    const location = useLocation();
    const navigate = useNavigate();
    const selectedRole = location.state && location.state.selectedRole;
    const isLogged = location.state && location.state.isLogged
    const authUser = location.state && location.state.authUser

    useEffect(()=> {

        axios.get("/cuts")
        .then((response) => {
          const data = response.data.data
          const sortedCuts =  data.sort((a,b) => a["0"]["sample_id"]-b["0"]["sample_id"])
          setAvailableCuts(sortedCuts)
        }
        ).catch((error) => {
          console.error(error);
        });


    
      },[setAvailableCuts])

    const handleCancel = (event) => {
        navigate('/dashboard', { state : { isLogged, selectedRole, authUser }})
      }

  return (
    <Container className='dash'>
    {availableCuts.map((cuts) => {

        return (           
          <option key={cuts["0"]["id"]} value={cuts["0"]["id"]}>Sample: {cuts["0"]["sample_id"]}  cut id: {cuts["0"]["id"]}, purpose: {cuts["0"]["purpose"]}, at {cuts["0"]["cut_date"]}</option>            
        );
      })}

      <Button className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>
      </Container>

      
  )
}


export default SamplesAndCuts