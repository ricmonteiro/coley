import React from 'react'
import { useNavigate, useLocation } from 'react-router-dom';
import { Form, Button, Alert } from 'react-bootstrap'
import { useState, useEffect } from 'react';
import axios from 'axios'


function CreateAnalysis() {
const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  const authUser = location.state && location.state.authUser

  const [availableCuts, setAvailableCuts] = useState([])
  const [successMessage, setSuccessMessage] = useState('')
  const [submitError, setSubmitError] = useState('')
  


  const [selectedDate, setSelectedDate] = useState('')
  const [selectedCut, setSelectedCut] = useState('')
  const [selectedFile, setSelectedFile] = useState(null);

  console.log(authUser[0]["id"])
  useEffect(()=> {

    axios.get("/cuts")
    .then((response) => {
      setAvailableCuts(response.data.data)
    }
    ).catch((error) => {
      console.error(error);
    });

  },[setAvailableCuts])


  const handleSubmit = (event) => {

    event.preventDefault();

    const formData = {
      userid: authUser[0]["id"],
      cutid: selectedCut,
      selectedDate: selectedDate,
      file: selectedFile,
      };

      console.log(formData)

      axios.post('/result_file_upload/', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      })
        .then(response => {
          setSuccessMessage(response.data.message)
        })
        .catch(error => {
          error.message = 'There was an error uploading the file'
          setSubmitError(error.message)
        });
  }

  const handleChangeCut = (event) => {
    setSelectedCut(event.target.value)
    console.log(event.target.value)
  } 
  
  const handleChangeDate = (event) => {
    setSelectedDate(event.target.value)
    console.log(event.target.value)    
  }

  const handleChangeFile = (event) => {
    setSelectedFile(event.target.files[0])
    console.log(event.target.files[0])
  }

  const handleCancel = (event) => {
    navigate('/dashboard', { state : { isLogged, selectedRole, authUser }})
  }

  return (

    <Form onSubmit={handleSubmit}>

        <h1>Upload a Result</h1>
        <Form.Label>Select cut to upload an analysis
        <Form.Select
        value={selectedCut}
        onChange={handleChangeCut}>
        <option value="" disabled>Select cut</option>
        {availableCuts.map((cuts) => {
        return (           
          <option key={cuts["0"]["id"]} value={cuts["0"]["id"]}> cut id: {cuts["0"]["id"]}, from sample: {cuts["0"]["sample_id"]} purpose: {cuts["0"]["purpose"]}, at {cuts["0"]["cut_date"]}</option>            
        );
      })}
    </Form.Select>
    </Form.Label>

    <Form.Label>File</Form.Label>
      <Form.Control
        type="file"
        name="file"
        onChange={handleChangeFile}/>

    <Form.Label>Select date</Form.Label>
        <Form.Control type="date" value={selectedDate} name="entry-date" placeholder="Date of Birth" onChange={handleChangeDate} />  
      
        <Form.Label>
    {(successMessage && <Alert variant='success'>{successMessage}</Alert>) || (submitError && <Alert variant='danger'>{submitError}</Alert>)}
        </Form.Label>
        <Button  className='button m-2' type="submit">Upload result file</Button>
        <Button  className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>
    </Form>

  )
}

export default CreateAnalysis