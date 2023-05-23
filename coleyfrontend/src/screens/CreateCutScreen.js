import React from 'react'
import { Form } from 'react-bootstrap'
import { useNavigate, useLocation } from 'react-router-dom';
import { useEffect, useState} from 'react';
import axios from 'axios'


function CreateCut() {
  const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  const authUser = location.state && location.state.authUser

  const [samples, setSamples] = useState([])


  const [selectedSample, setSelectedSample] = useState('')


  useEffect(() => { 
    if(isLogged){
      axios.get('/samples').then(resp => {
      console.log(resp.data.data[0]);
      setSamples(resp.data.data)
  });
  }else{navigate('/')}},[navigate])

  const handleChangeSample = (event) => {
    setSelectedSample(event.target.value)
  } 



  return (
    <Form>


      

        <h1>Create a cut from a sample</h1>

        <Form.Label>Select sample
          <Form.Select
        value={selectedSample}
        onChange={handleChangeSample}>
        <option value="" disabled>Select sample</option>
        {samples.map((sample) => {
        return (
          <option key={sample["0"]["id"]} value={sample["id"]}>sample id: {sample["0"]["id"]}, origin: {sample["0"]["origin"]}, from {sample["0"]["entry_date"]}</option>
        );
      })}

      </Form.Select>
      </Form.Label>


        
        

    </Form>
  )
}

export default CreateCut