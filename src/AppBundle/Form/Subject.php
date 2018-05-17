<?php

namespace AppBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use AppBundle\Entity\Discussions;
use Doctrine\ORM\EntityRepository;

/**
 * Класс формы создания/редактирования темы
 * @package AppBundle\Form
 */
class Subject extends AbstractType
{
    /**
     * @var string условие
     */
    protected $condition;

    /**
     * @var integer параметр
     */
    protected $parameter;

    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        if (!empty($options['section'])) {
            $this->condition = 'd.id = :var';
            $this->parameter = $options['section'];
        } else {
            $this->condition = 'd.type = :var';
            $this->parameter = 1;
        }
        $builder
            ->add('parent', EntityType::class, [
                'class' => Discussions::class,
                'query_builder' => function (EntityRepository $er) {
                    return $er->createQueryBuilder('d')
                        ->where($this->condition)
                        ->setParameter('var', $this->parameter);
                },
                'choice_label' => 'title',
                'label' => 'Раздел',
                'attr' => ['class' => 'form-control']
            ])
            ->add('title', TextType::class, [
                'label' => 'Заголовок',
                'attr' => ['class' => 'form-control']
            ])
            ->add('hidden', CheckboxType::class, [
                'required' => false,
                'label' => 'Скрытый для незарегистрированных'
            ])
            ->add('submit', SubmitType::class, [
                'attr' => [
                    'class' => 'btn btn-success pull-right'
                ],
                'label' => 'Сохранить'
            ]);
    }

    /**
     * @param OptionsResolver $resolver
     */
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Discussions::class,
            'section' => null
        ]);
    }
}