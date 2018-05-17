<?php

namespace AppBundle\Controller;

use AppBundle\Form\Write;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

/**
 * Контроллер формы обратной связи
 * @package AppBundle\Controller
 */
class WriteController extends Controller
{
    /**
     * Отправка формы
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function sendAction(Request $request)
    {
        $form = $this->createForm(Write::class);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            if ($this->captchaverify($request->get('g-recaptcha-response'))) {
                $formData = $form->getData();
                $this->get('app.security.write')->send($formData);
                $this->get('session')->getFlashBag()->add('success-notice', 'Ваше сообщение успешно отправлено.');
                return $this->redirect($request->headers->get('referer'));
            } else {
                $this->get('session')->getFlashBag()->add('error-notice', 'Введите каптчу!');
            }
        }
        return $this->render('@App/write/form.html.twig', [
            'form' => $form->createView()
        ]);
    }

    /**
     * Каптча
     * @param $recaptcha
     * @return mixed
     */
    function captchaverify($recaptcha) {
        $url = "https://www.google.com/recaptcha/api/siteverify";
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, [
            "secret" => "6LdiuVUUAAAAAMMDeOjji75pVEuXW1ooadyZqQJj",
            "response" => $recaptcha,
            "remoteip" => $_SERVER['REMOTE_ADDR']
        ]);
        $response = curl_exec($ch);
        curl_close($ch);
        $data = json_decode($response);
        return $data->success;
    }
}